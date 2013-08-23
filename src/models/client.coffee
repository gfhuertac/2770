orm = require 'orm'
db = require '../db'
config = require '../config'

# holds all the clients approved for API usage

module.exports = db 'client',
  columns:
    name: String
    secret: String
    redirectURL: String
    
  hooks:
    # client secrets are generated automatically
    beforeCreate: (cb) ->
      @secret = config.generator()
      cb()
      
  # sample validations
  # either you validate your stuff here
  # or you let your database handle this
  validations:
    name: [
      orm.enforce.unique(),
      orm.enforce.ranges.length(3, undefined)
    ]
