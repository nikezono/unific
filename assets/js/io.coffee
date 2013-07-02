###

  io.coffee
  クライアントサイドのsocket.io設定ファイル

###
$ ->

  ###
  # Initialize
  ###
  $('.alert').hide()
  $('button.close').click (e)->
    e.currentTarget.parentElement.style.display = "none"
  socket = io.connect()
  path   = window.location.pathname


  ###
  # Events
  ###

  ## Join Room(Stream)
  socket.on "connect", ->

    # if toppage
    unless inStream()

      ## Request Find-Stream
      $('#GoButton').click ->
        window.location.href = $('#GoInput').val()

    # if stream
    else
      socket.emit "connect stream", path
   
      ###
      # Helper Events
      ###

      ## Request Find-Feed
      $('#FindFeedButton').click ->
        $('#NoFeedIsFound').hide()
        inputed = $('#FindFeedInput').val()
        socket.emit 'find feed', inputed

      ## Receive Find-Feed
      socket.on 'found feed', (error,candidates)->
        $('#NoFeedIsFound').show() if error?
        if candidates?
          $('#CandidatesModalWindow').find('#CandidatesList').html('')
          for candidate in candidates
            candidate.title = candidate.url unless candidate.title?
            $('#CandidatesList').append "<li><input type='checkbox' value='#{candidate.url}'>  #{candidate.title}</li>"
          $('#CandidatesModalWindow').modal() 

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
      $('#AddFeedButton').click (e)->
        urls = []
        $('#CandidatesList').find(":checkbox:checked").each (i) ->
          urls[i] = $(this).val()
        unless urls.length is 0
          socket.emit 'add feed', urls
          $('#NewFeedIsAdded').show()


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