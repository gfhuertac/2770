config = require '../config'
crypto = require 'crypto'
winston = require 'winston'
qrcode = require '../qrcode_helper'
aws = require '../aws_helper'

QrCode = require '../models/qrcode'

generate = (data, filename, callback) ->
  # QR code generation
  qrcode.generate data, (error, buf) => 
    if error # there was an error creating the QR code
      winston.error error
      next error
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

# Module used as a controller for QR codes
module.exports = 
  # Method used to create a new QR code.
  # req must contain a variable called data containing string that will be used for the QR code
  retrieve: (req, res, next) ->
    data = req.params.data
    # Check that data exists in the request
    unless data
      error = new Error("Data cannot be empty")
      error.statusCode = 400
      next error
      return false
    # create hash to identify the data
    hashcode = crypto.createHash('md5').update(data).digest('hex')
    # and use it as the filename for the data
    filename = hashcode + ".png"
    # callback usef to return the data
    callback = (error, url) => 
      if error # there was an error uploading the object
        winston.error error
        next error
        return false
      else
        res.send { location: url }
    try
      if config.cache_qrcodes && !config.s3.use_private_urls # cache is only available for public URLs
        QrCode.find {hashcode: hashcode}, 1, (error, qrcodes) =>
          if qrcodes && qrcodes.length == 1
            location = qrcodes[0].location
            callback undefined, location
          else
            generate data, filename, callback
      else
        generate data, filename, callback
    catch error
      winston.error error
      next error
      return false
    true