db = require '../db'

module.exports = db 'user',
  columns:
    name: String
    # should not be stored as plaintext in production
    # but rather as salted SHA-2 hash, use beforeSave hook
    password: String