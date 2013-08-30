config = require('../config').s3
winston = require 'winston'
AWS = require 'aws-sdk'

# AWS configuration: we obtain the data from the config entity (see config.coffee on root folder)
AWS.config.update({ accessKeyId: config.access_key_id, secretAccessKey: config.secret_access_key });

module.exports =
  upload: (params, callback)
    unless config.use_private_urls # we want to use public URLs therefore ...
      params.ACL = 'public-read' # ... set the object to be publicly available
      
    s3 = new AWS.S3()
    s3.client.putObject params, (error, result) =>
      if error
        if callback
          callback error, undefined
          return false
        else
          throw error
      else
        # return the URL for the QR code
        if config.use_private_urls # if the URL should be private, then we create a signed URL
          delete params.Body
          delete params.ContentLength
          delete params.Metadata
          params.Expires = config.urls_expire_after || 900 # expiration time for the public URL
          url = s3.getSignedUrl 'getObject', params
          if callback
            callback undefined, url
        else
          if callback
            callback undefined, "http://s3.amazonaws.com/#{config.bucket_name}/#{filename}"
        true
      true
    true