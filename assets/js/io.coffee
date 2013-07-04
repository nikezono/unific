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
  path   = (window.location.pathname).substr(1)
  Articles = []

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

      # first sync
      socket.emit 'sync stream', path
      $('#NoFeedIsAdded').show() if Articles.length is 0

      ###
      # SetInterval Sync
      # Now Setting: 5 minutes
      ###
      setInterval ->
        console.log 'sync'
        socket.emit('sync stream',path)
      ,1000*60*5
   
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
            candCheckbox = "<li><input type='checkbox' title= '#{candidate.title}' value='#{candidate.url}'>  #{candidate.title}</li>"
            $('#CandidatesList').append candCheckbox
          $('#CandidatesModalWindow').modal() 

      ###
      # Stream Model Events
      ###

      ## Sync
      # when pushed 'sync' button

      # Sync Object Received
      socket.on 'sync completed' , (pages) ->
        Articles = Articles.concat pages
        Articles = _.uniq Articles,(obj)->
          return obj.page.title
        $('#NoFeedIsAdded').hide() unless Articles.length is 0
        $('#Articles').html('')
        for article in Articles
          appendArticle(article)

      ## Request List

      ## Receive List

      ## Request Change Property

      ## Receive Change Property


      ###
      # Feed Model Events
      ###

      ## Request Add-Feed
      $('#AddFeedButton').click (e)->
        urls  = []
        $('#CandidatesList').find(":checkbox:checked").each ->
          urls.push
            url:$(this).val()
            title:$(this).attr('title')
        unless urls.length is 0
          socket.emit 'add feed',
            urls  :urls
            stream:path

      ## Add Feed Succeed
      socket.on 'add-feed succeed',->
        $('#NewFeedIsAdded').show()
        console.log 'sync'
        socket.emit 'sync stream', path


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

      ## Some Error has Received
      socket.on 'error', ->
        $('#SomethingWrong').show()

  ###
  # private methods
  ###
  inStream = ->
    return false if path is ''
    return true

  appendArticle = (article)-> 
    title       = article.page.title
    comments    = article.page.comments
    description = article.page.description
    url         = article.page.url
    sitename    = article.feed.title
    siteurl     = article.feed.site
    $('#Articles').append "<li class='media well'><div class='contents'><a href='#' class='pull-left'><img src='/images/no_image.png' class='media-object'/></a><div class='media-body'><a href=#{url}><h4 class='media-heading'>#{title}<a href=#{siteurl}><small>  #{sitename}</small></a></h4><i class='icon-comments-alt'> 
 Comments(#{comments.length}) </i><i class='icon-star-empty'> starred</i></a><p> #{description}</p><button class='btn'>Read More</button>   <button class='btn btn-info'><i class='icon-star'></i>  Star</button></div></div></li>"