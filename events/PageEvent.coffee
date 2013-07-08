###

  PageEvent.coffee

###

module.exports.PageEvent = (app) ->

  ###
  # dependency
  ###
  ex = require 'extractcontent'

  Page   = app.get("models").Page

  ###
  # socket.io events
  ###

  getContents:(socket,data) ->
    ex.extractFromUrl data.url, (error, result) ->
      return socket.emit 'error' if error
      result.content = encodeURIComponent result.content.replace(/\n/g,'<br>')
      return socket.emit 'got page',
        res:result
        domid:data.domid

  addStar: (socket,data) ->
    console.log data

  deleteStar: (socket,data) ->
    console.log data

  addComment:(socket,io,data)->
    Page.findOne _id:data.domid, (err,page)->
      return socket.emit 'error' if err
      page.comments.push data.comment
      page.save()
      io.sockets.emit 'comment added',
        domid:data.domid
        comment:data.comment
        page:page

