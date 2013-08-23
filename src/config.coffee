module.exports =
  require_accept_version: true
  server_name: 'Pi API OAuth2 Server DEV'
  token_url: 'token'
  auth_realm: 'Pi API realm'
  generator: -> Math.random().toString(36).slice(2) + Math.random().toString(36).slice(2)
  database:
    user: "postgres"
    port: "5432"
    password: "pw123"
    host: "localhost"
    name: "restapi"
    override_url:  process.env.HEROKU_POSTGRESQL_NAVY_URL
    reset_tables: process.env.RESET_TABLES
