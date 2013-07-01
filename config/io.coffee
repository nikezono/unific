###

  io.coffee
  socket.ioのevent設定ファイル

###

RedisStore = require('socket.io/lib/stores/redis')
redis      = require('socket.io/node_modules/redis')
pub        = redis.createClient()
sub        = redis.createClient()
client     = redis.createClient()

path = require 'path'

module.exports = (app, server) ->

  # setup socket.io
  io = (require 'socket.io').listen server
  io.set 'store', new RedisStore
    redisPub: pub
    redisSub: sub
    redisClient: client

  # Routing
  io.sockets.on "connection", (socket) ->

    # on Connection
    socket.on "connect stream", (stream_name) ->
      socket.join stream_name
      socket.set 'stream_name', stream_name

    # Use Router
    (require path.resolve('routes','ioRoutes')) app,io,socket