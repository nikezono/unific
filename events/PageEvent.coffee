###

  PageEvent.coffee

###

module.exports.PageEvent = (app) ->

  ###
  # dependency
  ###

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

  addComment:(socket,io,data)->
    Page.findOne _id:data.domid, (err,page)->
      return socket.emit 'error' if err
      page.comments.push data.comment
      page.comments = _.uniq page.comments, (comment)->
        return comment
      page.save()
      io.sockets.to(data.stream).emit 'comment added',
        domid:data.domid
        comments:page.comments

