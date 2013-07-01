###

  io.coffee
  socket.ioのevent設定ファイル

###

module.exports = (app, server) ->

  # setup socket.io
  io = (require 'socket.io').listen server

  # Routing
  io.sockets.on "connection", (socket) ->

    # on Connection
    socket.on "connect stream", (stream_name) ->
      socket.join stream_name
      socket.set 'stream_name', stream_name

    # Use Router
    (require path.resolve('routes','ioRoutes')) io,socket