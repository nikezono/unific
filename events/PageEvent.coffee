###

  PageEvent.coffee

###

module.exports.PageEvent = (app) ->

  _  = require 'underscore'

  Page   = app.get("models").Page

  ###
  # socket.io events
  ###

  addStar: (socket,io,data) ->
    Page.findOne _id:data.domid,(err,page)->
      return socket.emit 'error' if err
      page.starred = true
      page.save()
      io.sockets.to(data.stream).emit 'star added',
        domid:data.domid


  deleteStar: (socket,io,data) ->
    Page.findOne _id:data.domid,(err,page)->
      return socket.emit 'error' if err
      page.starred = false
      page.save()
      io.sockets.to(data.stream).emit 'star deleted',
        domid:data.domid

