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

  ###
  # Init Event
  ###

  $('.alert').hide()
  $('button.close').click (e)->
    e.currentTarget.parentElement.style.display = "none"

  ###
  # Socket.io configration
  ###

  unless _.isEmpty path

    socket = io.connect()
    root.router = routes(socket)
    socket.on "connect", ->

        socket.emit "connect stream", path
        router.attachSingleEvent()
        $NoFeedIsAdded.show() if $Articles.html() is ''

        ###
        # SetInterval Sync
        # Now Setting: 3 minutes
        ###
        socket.emit 'sync stream',
          stream:path
          latest:latestPubDate()
        setInterval ->
          console.log 'sync by 3 minutes'
          socket.emit 'sync stream',
            stream:path
            latest:latestPubDate()
        ,1000*60*3

