###

  io.coffee
  クライアントサイドのsocket.io設定ファイル

###
$ ->

  ###
  # Init Event
  ###
  $('.alert').hide()
  $('button.close').click (e)->
    e.currentTarget.parentElement.style.display = "none"

  ###
  # Page Global Variables
  ###

  socket = io.connect()
  path   = (window.location.pathname).substr(1)
  first    = true 
  Articles = []

  ###
  # Dom 
  ###
  $Articles = $('#Articles')

  ###
  # Events()
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
      if first
        socket.emit 'sync stream', path
        $('#NoFeedIsAdded').show() if $Articles.html() is ''
        first = false

      ###
      # SetInterval Sync
      # Now Setting: 1 minutes
      ###
      setInterval ->
        console.log 'sync'
        socket.emit 'sync stream',path
      ,1000*60
   
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
            candidate.siteurl   = response.url
            $('#CandidatesList').append ViewHelper.candCheckbox(candidate)
          $('#CandidatesModalWindow').modal() 

      ###
      # Stream Model Events
      ###

      ## Sync
      # when pushed 'sync' button

      # Sync Object Received
      socket.on 'sync completed' , (pages) ->
        #更新昇順
        filtered = _.sortBy pages, (obj)->
          return Date.parse obj.page.pubDate

        $('#NoFeedIsAdded').hide() unless pages.length is 0
        for article in filtered
          appendArticle(article)
        PageAndCommentEvent()
        StarButtonEvent()
        $('#NewArticleIsAdded').show().fadeIn(500) if filtered.length > 0

      ## Request List
      $('#EditFeedButton').click (e)->
        socket.emit 'get feed_list', path

      ## Receive List
      socket.on 'got feed_list', (list)->
        if list?
          $('#EditFeedModalWindow').find('#FeedList').html('')
          for feed in list
            $('#FeedList').append ViewHelper.feedList(feed)
          $('#EditFeedModalWindow').modal()

      ## Request Edit Feed List
      $('#ApplyEditFeedButton').click (e)->
        urls = []
        $('#EditFeedModalWindow').find('#FeedList').find(":checkbox:checked").each ->
          urls.push $(this).attr('url')
        socket.emit 'edit feed_list',
          urls: urls
          stream:path

      ## Receive Edit Feed List
      socket.on 'edit completed', ->
        $('#FeedListIsEditted').show()
        Articles = []
        $Articles.html('')
        console.log 'sync by feed_list editted'
        socket.emit 'sync stream', path

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



      ###
      # Page Model Events
      # prependされるためjQueryEventはPackageにまとめる
      ###

      ## Receive Add Star
      socket.on 'star added', (data)->
        $dom = $(document).find("##{data.domid}")
        $dom.find('span.starred').html(ViewHelper.starredIcon(true))
        $dom.find('span.starButton').html(ViewHelper.starredButton(true))
        StarButtonEvent()

      ## Receive Delete Star
      socket.on 'star deleted', (data)->
        $dom = $(document).find("##{data.domid}")
        $dom.find('span.starred').html(ViewHelper.starredIcon(false))
        $dom.find('span.starButton').html(ViewHelper.starredButton(false))
        StarButtonEvent()

      ## Receive Add Comment
      socket.on 'comment added', (data)->
        $dom = $(document).find("##{data.domid}")
        $dom.find('.comments').html('')
        for comment in data.comments
          $dom.find('.comments').append("<blockquote>#{comment}</blockquote>")
        $dom.find('.commentsLength').text(data.comments.length)

      ## Some Error has Received
      socket.on 'error', ->
        $('#SomethingWrong').show()

      ###
      # PrependされるjQuery Events
      ###

      PageAndCommentEvent = ->

        ## FancyBox
        $(".fancy").fancybox
          fitToView : false
          width   : '70%'
          height    : '100%'
          autoSize  : true
          closeClick  : true
          openEffect  : 'none'
          closeEffect : 'none'

        ## Read More
        $('.read-more').click (e)->
          $dom = $(this).parent()
          $dom.find('a.fancy').click()

        ## Request Add Comment
        $('.submitComment').click (e)->
          $dom = $(this).parent()
          comment = $dom.find('.inputComment').val()
          if comment?
            socket.emit 'add comment',
              domid: $dom.attr('id')
              comment:comment
              stream :path



      StarButtonEvent = ->
        ## Request Add/Delete Star
        $('.starredButton').click (e)->
          $dom = $(this).parent().parent()
          act  = $(this).attr('value')
          if act is 'star'
            socket.emit 'add star',
              domid: $dom.attr('id')
          else if act is 'unstar'
            socket.emit 'delete star',
              domid: $dom.attr('id')
              stream:path

  ###
  # private methods
  ###

  # 現在パスからStream内かTopPageか判定
  inStream = ->
    return false if path is ''
    return true

  # 記事の追加
  appendArticle = (article)-> 
    variables = 
      title       : article.page.title
      id          : article.page._id
      comments    : article.page.comments
      description : article.page.description
      pubDate     : article.page.pubDate
      url         : article.page.url
      sitename    : article.feed.title
      siteurl     : article.feed.site
      starred     : article.page.starred

    ## Comment HTML
    commentHTML = ''
    for comment in article.page.comments
      commentHTML += ViewHelper.comment(comment)

    ## Articlesのfeedの先頭よりpubDateが新しければprepend
    topPubDate  = $Articles.find('li:first').attr('pubDate')
    thisPubDate = Date.parse(variables.pubDate)
    pubDateIsNewer = ( thisPubDate >= topPubDate)
    noArticles   = (topPubDate is undefined)

    ## 同名記事はPrependしない
    thisTitle = variables.title
    duplicate = thisTitle in Articles

    ## Prepend
    if (pubDateIsNewer and not duplicate) or noArticles
      $Articles.prepend( ViewHelper.mediaHead(variables) + commentHTML + ViewHelper.mediaFoot(variables)).hide().fadeIn(500)
      Articles.push thisTitle




