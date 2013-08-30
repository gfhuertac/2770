2770
====

Repository for CloudSpokes Challenge 2770

Configuration

- Configure a BUILDPACK that supports the cairo package, used by qrcode
  In our case, we configure it running:
  heroku config:add BUILDPACK_URL=git://github.com/mojodna/heroku-buildpack-nodejs.git#cairo

- Add a postgresql database to the heroku instance:
  heroku addons:add heroku-postgresql:dev

- Change the configuration file to reflect the database URL
  
- git push heroku master

- heroku open
