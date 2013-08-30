https = require 'https'

# sample query controller

module.exports =

  performQuery: (req, res, next) ->        
    data = ""
    
    callback = (googleRes) ->
      googleRes.on 'data', (chunk) ->
        data += chunk
      googleRes.on 'end', ->
        res.json { googleResponse: JSON.parse data }
        
    https.request({
      host: 'maps.googleapis.com'
      path: "/maps/api/place/textsearch/json?query=#{req.params.query}&sensor=false&key=AIzaSyDH4cnXocDAb7lZqpqzo1IeiheZ04L8Jy0"
    }, callback).end()