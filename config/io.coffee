###

  io.coffee
  socket.ioのevent設定ファイル

###

path  = require 'path'
debug = require('debug')('config/io')

module.exports = (app, server) ->

  Stream      = app.get('models').Stream
  Feed        = app.get('models').Feed
  Page        = app.get('models').Page
  HelperEvent = app.get('events').HelperEvent app


  # setup socket.io
  io = (require 'socket.io').listen server

  app.get('emitter').on 'new article',(data)->
    Stream.findBySubscribedFeedId data.feed._id,(err,streams)->
      return debug err if err
      for stream in streams
        debug("publish article to stream #{stream.title}")
        io.of("/#{stream.title}").emit 'newArticle',data

  # Routing
  io.sockets.on "connection", (socket) ->

    # on Error
    socket.on "error", (exc)->
      debug exc

    # Use Router
    (require path.resolve('routes','ioRoutes')) app,io,socket
