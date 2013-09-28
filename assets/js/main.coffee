###
#
#  main.coffee
#
###

root = exports ? this
root.path = (window.location.pathname).substr(1)

root.accessToken = ''

$ ->

  ###
  # Init Event
  ###
  socket = io.connect()

  # 以後サーバとの通信に使用するAccessTokenをグローバル変数化する
  socket.on 'auth',(acToken)->
    accessToken = acToken