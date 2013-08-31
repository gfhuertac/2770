db = require '../db'

# QR code model

module.exports = db 'qrcode',
  columns:
    hashcode: String
    data: String
    location: String
    until: Number