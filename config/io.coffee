###

  io.coffee
  socket.ioのevent設定ファイル

###

path  = require 'path'
debug = require('debug')('config/io')

module.exports = (app, server) ->

  # setup socket.io
  io = (require 'socket.io').listen server

  # Routing
  io.sockets.on "connection", (socket) ->

    # on Connection
    socket.on "connect stream", (streamName) ->
      socket.join streamName
      socket.set 'streamName', streamName

    # on Error
    socket.on "error", (exc)->
      debug exc
      process.exit 1

    # Use Router
    (require path.resolve('routes','ioRoutes')) app,io,socket
