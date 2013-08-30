Widget = require '../models/widget'

# sample CRUD controller

module.exports = 
    
  create: (req, res, next) ->
    Widget.create {
      name: req.params.name
      description: req.params.name
    }, (err, widget) ->
      if err
        next(err)
      else
        res.send { widget }
    
  index: (req, res, next) ->
    Widget.find (err, widgets) ->
      if err
        next(err)
      else
        res.send { widgets }
    
  show: (req, res, next) ->
    Widget.get req.params.id, (err, widget) ->
      if err
        next(err)
      else
        res.send { widget }
    
  update: (req, res, next) ->
    Widget.get req.params.id, (err, widget) ->
      if err
        next(err)
      else
        widget.save {
          name: req.params.name
          description: req.params.description
        }, (err) ->
          if err
            next(err)
          else
            res.send { widget }
      
  destroy: (req, res, next) ->
    Widget.get req.params.id, (err, widget) ->
      if err
        next(err)
      else
        widget.remove (err) -> 
          if err
            next(err)
          else
            res.send { message: "removed successfully" }
