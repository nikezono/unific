###
#
#  main.coffee
#
###

###
# Define Global Variables
###

root = exports ? this
root.path = (window.location.pathname).substr(1)

$ ->

  first = true  # 初回読み込み時のSyncイベントフラグ

  ###
  # Init Event
  ###

  $('.alert').hide()
  $('button.close').click (e)->
    e.currentTarget.parentElement.style.display = "none"

  ###
  # Socket.io configration
  ###

  socket = io.connect()
  root.router = routes(socket)
  socket.on "connect", ->

    socket.emit "connect stream", path unless _.isEmpty path
    router.attachSingleEvent()

    # 初回読み込み
    if first
      socket.emit 'sync stream', path
      $NoFeedIsAdded.show() if $Articles.html() is ''
      first = false
    
    ###
    # SetInterval Sync
    # Now Setting: 1 minutes
    ###
    setInterval ->
      console.log 'sync by 1minutes'
      socket.emit 'sync stream',path
    ,1000*60

