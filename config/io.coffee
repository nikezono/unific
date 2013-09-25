###

  io.coffee
  socket.ioのevent設定ファイル

###

RedisStore = require('socket.io/lib/stores/redis')
redis      = require('socket.io/node_modules/redis')

express    = require 'express'

path = require 'path'

module.exports = (app, server) ->

  # setup socket.io
  io = (require 'socket.io').listen server
  io.set 'store', new RedisStore
    redisPub: redis.createClient()
    redisSub: redis.createClient()
    redisClient: redis.createClient()
  io.set 'browser client minification', yes
  io.set 'browser client etag', yes

  # socket.io+Passport
  io.set 'authorization', (data, accept) ->
    data.user = {}
    return accept null, yes unless data.headers?.cookie?
    (express.cookieParser app.get('secret')) data, {}, (err) ->
      return accept err, no if err
      return app.get('session').load data.signedCookies['connect.sid'], (err, session) ->
        console.error err if err
        return accept err, no if err
        data.user = session.passport.user if session
        return accept null, yes

  # Routing
  io.sockets.on "connection", (socket) ->
    session = socket.handshake.user
    console.log "user #{session} is log in." if session?

    # on Connection
    socket.on "connect stream", (stream_name) ->
      socket.join stream_name
      socket.set 'stream_name', stream_name

    # on Error
    socket.on "error", (exc)->
      console.error "socket.io Error:exc"

    # Use Router
    (require path.resolve('routes','ioRoutes')) app,io,socket