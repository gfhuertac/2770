2770
====

Repository for CloudSpokes Challenge 2770

Configuration

- Configure a BUILDPACK that supports the cairo package, used by qrcode
  In our case, we configure it running:
  heroku config:add BUILDPACK_URL=git://github.com/mojodna/heroku-buildpack-nodejs.git#cairo

- 