restify = require 'restify'
oauth2 = require 'restify-oauth2'
winston = require 'winston'
config = require './config'
routes = require './routes'
auth_hooks = require './auth_hooks'
db = require './db'
_ = require 'underscore'

# configure the server
server = restify.createServer
  name: config.server_name

# enable resitfy plugins
server.use restify.authorizationParser()
server.use restify.bodyParser()
  
# require header field "Accept-Version" to be set ?
if config.require_accept_version
  server.use (req, res, next) ->
    if req.header('Accept-Version') is undefined and req.url.slice(1) isnt config.token_url
      res.send 400, message: "no Accept-Version header supplied"
    else
      next req

# setup oauth2
oauth2.ropc server,
  hooks: auth_hooks
  tokenEndpoint: config.token_url
  wwwAuthenticateRealm: config.auth_realm
  
# setup routes
_.each routes, (details, route) ->
  controller = require './controllers/' + details.controller
  _.each details.actions, (action, method) ->
    version = details.version ? '1.0.0'
    server[method] { path: route, version: version }, (req, res, next) ->
      if details.public or req.username
        winston.info "#{method.toUpperCase()} #{req.url} (#{version}) as #{req.username}"
        res.header('Version', version)
        controller[action](req, res, next)
      else
        winston.info "not authorized: #{method.toUpperCase()} #{req.url}"
        res.sendUnauthorized()

process.on 'uncaughtException', (err) ->
  winston.error "Caught exception: #{err.stack}"

# start the server
server.listen process.env.PORT ? 3333, ->
   winston.info "#{server.name} listening at #{server.url}"
