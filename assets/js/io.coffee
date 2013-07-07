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
      socket.on 'found feed', (error,response)->
        $('#NoFeedIsFound').show() if error?
        if response.candidates?
          $('#CandidatesModalWindow').find('#CandidatesList').html('')
          for candidate in response.candidates
            candidate.sitetitle = "#{candidate.sitename} - #{candidate.title or 'feed'}"
            candCheckbox = "<li><input type='checkbox' siteurl=#{response.url} title= '#{candidate.sitetitle}' value='#{candidate.url}'>  #{candidate.sitetitle}</li>"
            $('#CandidatesList').append candCheckbox
          $('#CandidatesModalWindow').modal() 

      ###
      # Stream Model Events
      ###

      ## Sync
      # when pushed 'sync' button

      # Sync Object Received
      socket.on 'sync completed' , (pages) ->
        # ArticlesとPagesを比較していってPagesから差分だけ取ってくる
        filterNewArticles Articles,pages, (filtered)->
          if filtered.length > 0
            console.log 'new article added' 
          else
            console.log 'no article added'
          Articles = Articles.concat filtered
          Articles = _.uniq Articles,(obj)->
            return obj.page._id

          $('#NoFeedIsAdded').hide() unless Articles.length is 0
          for article in filtered
            appendArticle(article)
          $('#NewArticleIsAdded').show().fadeIn(500) if filtered.length > 0

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
            siteurl:$(this).attr('siteurl')
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

  filterNewArticles = (Articles,pages,callback)->
    ids = _.map Articles, (article)->
      return article.page._id
    filtered =  _.filter pages, (article)->
      return false if _.contains ids,article.page._id
      return true
    callback(filtered)

  appendArticle = (article)-> 
    title       = article.page.title
    comments    = article.page.comments
    description = article.page.description
    pubDate     = moment(article.page.pubDate).fromNow()
    url         = article.page.url
    sitename    = article.feed.title
    siteurl     = article.feed.site
    $('#Articles').prepend("<li class='media well'><div class='media-body'><a href=#{url}><h4 class='media-heading'>#{title}   
      <a href='#{siteurl}''>   <small>#{sitename}</small></a></h4><i class='icon-pencil'> #{pubDate}</i>  <i class='icon-comments-alt'> 
 Comments(#{comments.length}) </i><i class='icon-star-empty'> starred</i></a><p>#{description}</p><button class='btn'>Read More</button>   <button class='btn btn-info'><i class='icon-star'></i>  Star</button></div></li>").hide().fadeIn(300)