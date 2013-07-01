###

  io.coffee
  クライアントサイドのsocket.io設定ファイル

###

socket = io.connect()
path   = window.location.pathname


###
# Events
###

## Join Room(Stream)
socket.on "connect", ->
  console.log 'socket.io connected'
  if inStream()
    console.log "connect stream: #{path}"
    socket.emit "connect stream", path
  else
    console.log 'toppage'


###
# Helper Events
###

## Request Find-Feed

## Receive Find-Feed


###
# Stream Model Events
###

## Sync
# when handshake

# when pushed 'sync' button

## Request List

## Receive List

## Request Change Property

## Receive Change Property


###
# Feed Model Events
###

## Request Add-Feed

## Receive Delete-Feed

## Request Active-Feed

## Request Inactive-Feed

###
# Page Model Events
###

## Request Page Contents

## Receive Page Contents

## Request Add Star

## Receive Add Star

###
# Comment Model Events
###

## Request Add Comment

## Receive Add Comment

###
# private methods
###
inStream = ->
  return false if path is '/'
  return true 