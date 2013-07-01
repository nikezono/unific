###

  io.coffee
  socket.ioのevent設定ファイル

###

module.exports = (app, server) ->

  # include events
  homeEvent   = app.get('events').homeEvent app
  streamEvent = app.get('events').streamEvent app

  # setup socket.io
  io = (require 'socket.io').listen server

  # Routing
  io.sockets.on "connection", (socket) ->

    socket.on "connect stream", (stream_name) ->
      socket.join stream_name
      socket.set 'stream_name', stream_name

