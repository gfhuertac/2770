config = require('../config').s3
crypto = require 'crypto'
winston = require 'winston'
QrCode = require 'qrcode'
AWS = require 'aws-sdk'

# AWS configuration: we obtain the data from the config entity (see config.coffee on root folder)
AWS.config.update({ accessKeyId: config.access_key_id, secretAccessKey: config.secret_access_key });

# Module used as a controller for QR codes
module.exports = 
  # Method used to create a new QR code.
  # req must contain a variable called data containing string that will be used for the QR code
  generate: (req, res, next) ->
    try
      data = req.params.data
      # Check that data exists in the request
      unless data
        error = new Error("Data cannot be empty")
        error.statusCode = 400
        winston.error error
        next error
        return false
      # Check that the size of the data is valid, and set the error correction level based on it
      size = data.length
      correct = undefined
      if size < 1273
        correct = "max"
      else if size < 1663
        correct = "high"
      else if size < 2331
        correct = "medium"
      else if size < 2953
        correct = "minimum"
      else
        error = new Error("Data is too large to create a QR code")
        error.statusCode = 400
        winston.error error
        next error
        return false
  
      QrCode.draw data, correct, (error,canvas) =>
        if error
          winston.error error
          next error
          return false
        
        canvas.toBuffer (error, buf) => 
          if error
            winston.error error
            next error
            return false
          else
            filename = crypto.createHash('md5').update(data).digest('hex') + ".png"
            s3 = new AWS.S3()
            params = 
              Bucket: config.bucket_name,
              Key: filename,
              Body: buf
              ContentLength: buf.length
              Metadata:
                Content: data
            unless config.use_private_urls
              params.ACL = 'public-read'
            s3.client.putObject params, (error, result) =>
              if error
                winston.error error
                next error
                return false
              else
                # return the URL for the QR code
                if config.use_private_urls
                  delete params.Body
                  delete params.ContentLength
                  delete params.Metadata
                  params.Expires = config.urls_expire_after || 900
                  url = s3.getSignedUrl 'getObject', params
                  res.send( url  )
                else
                  res.send( "http://#{config.bucket_name}.s3.amazon.com/#{filename}"  )
                true
              true
          true
    catch error
      winston.error error
      next error
      return false
    true