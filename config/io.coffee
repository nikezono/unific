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

  # 新着記事
  app.get('emitter').on 'new article',(data)->
    Stream.findBySubscribedFeedId data.feed._id,(err,streams)->
      return debug err if err
      for stream in streams
        debug("publish article to stream #{stream.title}")
        io.of("/#{stream.title}").emit 'newArticle',data

  # Sub/UnSub
  # @todo Streamに対応
  app.get('emitter').on "subscribe",(data)->
    Stream.findBySubscribedFeedId data.mode._id,(err,streams)->
      return debug err if err
      for stream in streams
        debug("subscribed #{data.model.title} in stream #{stream.title}")
        io.of("/#{stream.title}").emit 'subscribed',
          title:data.model.title
  app.get('emitter').on "unsubscribe",(data)->
    Stream.findBySubscribedFeedId data.mode._id,(err,streams)->
      return debug err if err
      for stream in streams
        debug("unsubscribed #{data.model.title} in stream #{stream.title}")
        io.of("/#{stream.title}").emit 'unsubscribed',
          title:data.model.title

  # Routing
  io.sockets.on "connection", (socket) ->

    # on Error
    socket.on "error", (exc)->
      debug exc

    # Use Router
    (require path.resolve('routes','ioRoutes')) app,io,socket
