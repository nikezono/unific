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

  addStar: (socket,data) ->
    console.log data

  deleteStar: (socket,data) ->
    console.log data

  addComment:(socket,io,data)->
    Page.findOne _id:data.domid, (err,page)->
      return socket.emit 'error' if err
      page.comments.push data.comment
      page.comments = _.uniq page.comments, (comment)->
        return comment
      page.save()
      io.sockets.emit 'comment added',
        domid:data.domid
        comments:page.comments

