config = require '../config'
crypto = require 'crypto'
winston = require 'winston'
qrcode = require '../qrcode_helper'
aws = require '../aws_helper'

QrCode = require '../models/qrcode'

# Module used as a controller for QR codes
module.exports = 
  generate: (data, filename, callback) ->
    console.log "Filename #{filename}"
    # QR code generation
    qrcode.generate data, (error, buf) => 
      if error # there was an error creating the QR code
        callback error, undefined
        return false
      
      # then we create the params for the object
      params = 
        Bucket: config.s3.bucket_name,
        Key: filename,
        Body: buf
        ContentLength: buf.length
        Metadata:
          Content: data
          
      # AWS S3 upload
      aws.upload params, callback
      true
    true

  # Method used to create a new QR code.
  # req must contain a variable called data containing string that will be used for the QR code
  retrieve: (req, res, next) ->
    qrdata = req.params.qrdata
    # Check that data exists in the request
    unless qrdata
      error = new Error("Data cannot be empty")
      error.statusCode = 400
      next error
      return false
    # create hash to identify the data
    hcode = "" + crypto.createHash('md5').update(qrdata).digest('hex')
    # and use it as the filename for the data
    filename = hcode + ".png"
    console.log "Filename 2 #{filename}"
    # callback usef to return the data
    callback = (error, url) => 
      if error # there was an error uploading the object
        winston.error error
        next error
        return false
      validity = 0
      ttl = config.s3.urls_expire_after || 900
      if config.s3.use_private_urls
        validity = (new Date()) + ttl * 1000
      QrCode.create {
        hcode: hcode
        qrdata: qrdata
        location: url
        until: validity
      }, (err) ->
        if err
          winston.error err
      res.send { location: url }
    try
      if config.cache_qrcodes
        QrCode.find {hcode: hcode}, 1, (error, qrcodes) =>
          if qrcodes && qrcodes.length == 1
            validity = qrcodes[0].until
            if validity == 0 || validity < (new Date()).getTime()
              url = qrcodes[0].location
              res.send { location: url }
              return
          generate qrdata, filename, callback
      else
        generate qrdata, filename, callback
    catch error
      winston.error error
      next error
      return false
    true