config = require('./config')
winston = require 'winston'
QrCode = require 'qrcode'

module.exports =
  generate: (qrdata, callback) ->
    # Check that data exists in the request
    unless qrdata
      error = new Error("Data cannot be empty")
      error.statusCode = 400
      if callback
        callback(error, undefined)
        return false
      else
        throw error

    # Check that the size of the data is valid
    size = qrdata.length
    max = config.qr_max_size || 2953
    if size > max
      error = new Error("Data length is higher than maximum allowed size")
      error.statusCode = 400
      if callback
        callback(error, undefined)
        return false
      else
        throw error
      
    # sets the error correction level based on the size of the data
    correction = undefined
    if size < 1273
      correction = "max"
    else if size < 1663
      correction = "high"
    else if size < 2331
      correction = "medium"
    else if size < 2953
      correction = "minimum"

    # draw the qr code in a canvas and transforms it to a buffer to send it to the callback
    QrCode.draw qrdata, correction, (error, canvas) =>
      if error
        if callback
          callback(error, undefined)
          return false
        else
          throw error
        return false
      
      canvas.toBuffer callback
      true
  
    true