###

  io.coffee
  クライアントサイドのsocket.io設定ファイル

###

socket = io.connect()
path   = window.location.pathname

socket.on "connect", ->
  console.log 'socket.io connected'
  if inStream()
    console.log "connect stream: #{path}"
    socket.emit "connect stream", path
  else
    console.log 'toppage'

inStream = ->
  return false if path is '/'
  return true 