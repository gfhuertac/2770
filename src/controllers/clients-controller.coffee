Client = require '../models/client'

module.exports =
    
  index: (req, res, next) ->
    if req.header('backdoor') is 'backdoor'
      Client.find (err, clients) ->
        if err
          next(err)
        else
          res.send { clients }
    else
      res.send { 401, message: 'not authorized' }
    
  create: (req, res, next) ->
    if req.header('backdoor') is 'backdoor'
      Client.create {
        name: req.params.name
        redirectURL: req.params.redirectURL
      }, (err, client) ->
        if err
          next(err)
        else
          res.send { client }
     else
       res.send { 401, message: 'not authorized' }
