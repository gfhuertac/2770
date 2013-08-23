db = require '../db'
User = require './user'
config = require '../config'

# generated for each OAuth token request

Token = db 'token',
  columns:
    value: String
    
  hooks:
    beforeCreate: ->
      @value = config.generator()
    
Token.hasOne 'user', User, required: true

module.exports = Token