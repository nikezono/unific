###

  io.coffee
  socket.ioのevent設定ファイル

###

path  = require 'path'
debug = require('debug')('config/io')

module.exports = (app, server) ->

  Subscribe = app.get('models').Subscribe

  # setup socket.io
  io = (require 'socket.io').listen server

  app.on 'new article',(data)->
    Subscribe.findStreamByFeed data.feed, (streams)->
      for stream in streams
        debug("publish article to stream#{stream.title}")
        io.to(stream.title).emit data

  # Routing
  io.sockets.on "connection", (socket) ->

    # on Connection
    socket.on "connect stream", (streamName) ->
      if streamName
        socket.join streamName
      else # GlobalStream @todo
        debug "home"

    # on Error
    socket.on "error", (exc)->
      debug exc
      process.exit 1

    # Use Router
    (require path.resolve('routes','ioRoutes')) app,io,socket
