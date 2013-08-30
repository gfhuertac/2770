config = require('./config').database
winston = require 'winston'
orm = require 'orm'

db = orm.connect config.override_url ? "postgres://#{config.user}:#{config.password}@#{config.host}:#{config.port}/#{config.name}"

db.on 'connect', (err, db) ->
  throw err if err
  winston.info 'connected to database'
  
# exports a function used to define models
models = {}
module.exports = (name, options) ->
  throw "model #{name} already exists" if models[name]
  winston.info "defining model: #{name}"
  models[name] = db.define name, options?.columns, options
 
  if config.reset_tables
    db.on 'connect', (err, db) ->
      winston.info "creating table for model: #{name}"
      models[name].drop ->
        models[name].sync (err) -> throw err if err

  models[name]