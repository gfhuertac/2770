db = require '../db'

# QR code model

module.exports = db 'qrcode',
  columns:
    hcode: String
    qrdata: String
    location: String
    until: Number