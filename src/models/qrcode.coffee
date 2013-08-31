db = require '../db'

# QR code model

module.exports = db 'qrcode',
  columns:
    hashcode: String
    qrdata: String
    location: String
    until: Number