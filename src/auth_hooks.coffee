winston = require 'winston'
Client = require './models/client'
Token = require './models/token'
User = require './models/user'

# used to create a single token for the supplied user
createToken = (user, cb) ->
  Token.create { user_id: user.id }, (err, token) -> 
    cb(err, token.value)

module.exports =

  # validate existing clients only
  validateClient: (clientId, clientSecret, cb) ->
    winston.info "validating client: #{clientId}"
    Client.find { name: clientId }, (err, clients) ->
      cb(err) if err
      if clients.length is 1
        cb(null, clients[0].secret is clientSecret)
      else
        cb(null, false)
      
  # just create token, dont mind the username / password for now
  grantUserToken: (username, password, cb) ->
    winston.info "token requested: #{username}"
    User.find { name: username }, (err, users) ->
      cb(err) if err
      if users.length is 1 and users[0].password is password
        createToken(users[0], cb)
      else
        if users.length is 0
          User.create { name: username, password: password }, (err, user) ->
            cb(err) if err
            createToken(user, cb)
        else
          cb(null, false)
    
  # tokens are valid as long as they exist in the database
  # expiration would be checked here
  authenticateToken: (token, cb) ->
    winston.info 'authenticating token'
    Token.find { value: token }, (err, tokens) ->
      cb(err) if err
      if tokens.length is 1
        tokens[0].getUser (err, user) ->
          cb(err, user.name)
      else
        cb(null, false) 