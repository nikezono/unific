###

  io.coffee
  socket.ioのevent設定ファイル

###

path  = require 'path'
debug = require('debug')('config/io')
async = require 'async'
_     = require 'underscore'

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
      targetArray = _.pluck streams,'title'
      async.forEach streams,(stream,cb)->
        Stream.findBySubscribedStreamId stream._id,(err,subStreams)->
          if err
            debug err
            return cb()
          subArray = _.pluck(subStreams,'title')
          targetArray = _.union targetArray,subArray
          return cb()
      ,->
        for title in targetArray
          debug("publish article to stream #{title}")
          io.of("/#{title}").emit 'newArticle',data

  # Sub/UnSub
  app.get('emitter').on "subscribed",(data)->
    targetArray = [data.stream.title]
    Stream.findBySubscribedStreamId data.stream._id,(err,streams)->
      return debug err if err
      if not _.isEmpty streams
        targetArray = _.union targetArray,_.pluck(streams,'title')

      for title in targetArray
        debug("unsubscribed #{data.model.title} in stream #{title}")
        io.of("/#{title}").emit 'subscribed',
          title:data.model.title

  app.get('emitter').on "unsubscribed",(data)->
    targetArray = [data.stream.title]
    Stream.findBySubscribedStreamId data.stream._id,(err,streams)->
      return debug err if err
      if not _.isEmpty streams
        targetArray = _.union targetArray,_.pluck(streams,'title')

      for title in targetArray
        debug("unsubscribed #{data.model.title} in stream #{title}")
        io.of("/#{title}").emit 'unsubscribed',
          title:data.model.title

  # Routing
  io.sockets.on "connection", (socket) ->

    # on Error
    socket.on "error", (exc)->
      debug exc

    # Use Router
    (require path.resolve('routes','ioRoutes')) app,io,socket
