config = require('../config').s3
crypto = require 'crypto'
winston = require 'winston'
qrcode = require '../qrcode_helper'
aws = require '../aws_helper'

# Module used as a controller for QR codes
module.exports = 
  # Method used to create a new QR code.
  # req must contain a variable called data containing string that will be used for the QR code
  generate: (req, res, next) ->
    try
      data = req.params.data
      # QR code generation
      qrcode.generate req.params, (error, buf) => 
        if error # there was an error creating the QR code
          winston.error error
          next error
          return false
        
        # we create a hash as the filename for the QR code
        filename = crypto.createHash('md5').update(data).digest('hex') + ".png"
        # then we create the params for the object
        params = 
          Bucket: config.bucket_name,
          Key: filename,
          Body: buf
          ContentLength: buf.length
          Metadata:
            Content: data
            
        # AWS S3 upload
        aws.upload params, (error, url) =>
          if error # there was an error uploading the object
            winston.error error
            next error
            return false
          else
            res.send { location: url }
        true
    catch error
      winston.error error
      next error
      return false
    true