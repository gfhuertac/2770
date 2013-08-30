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
  s3:
    username: "cs-dev"
    access_key_id: "AKIAIB5ZGDYW6F4JQ4HA"
    secret_access_key: "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"
    bucket_name: "brivolabs-qrcodes"
    use_private_urls: false # if true then only signed URLs are provided to users
    urls_expire_after: 3600 # if using private URLs, then those URLs will expired after this amount of seconds
