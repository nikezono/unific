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
  first    = true 

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
        $('#NoFeedIsAdded').show() if Articles.length is 0
        first = false

      ###
      # SetInterval Sync
      # Now Setting: 1 minutes
      ###
      setInterval ->
        console.log 'sync'
        socket.emit('sync stream',path)
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
            candidate.url       = response.siteurl
            $('#CandidatesList').append ViewHelper.candCheckbox(candidate)
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
          #マージ
          Articles = Articles.concat filtered
          #重複削除
          Articles = _.uniq Articles,(obj)->
            return obj.page.link or obj.page._id
          #更新昇順
          filtered = _.sortBy filtered, (obj)->
            return Date.parse obj.page.pubDate

          $('#NoFeedIsAdded').hide() unless Articles.length is 0
          for article in filtered
            appendArticle(article)
          PageAndCommentEvent()
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
      # prependされるためPackage
      ###
      PageAndCommentEvent = ->

        ## Request Page Contents
        $('.btn-toggle').click (e)->
          $dom = $(this).parent()
          if $(this).text() is 'Close'
            $dom.find('p.desc').show()
            $dom.find('p.contents').hide()
            $(this).text('Read More')
          else if $dom.find('p.contents').text() isnt ''
            $dom.find('p.desc').hide()
            $dom.find('p.contents').show()
            $dom.find('.btn-toggle').text('Close')
          else
            socket.emit 'get page',
              domid: $dom.attr('id')
              url  : $dom.find('a').attr('href')

        ## Receive Page Contents
        socket.on 'got page',(data)->
          content = decodeURIComponent data.res.content
          $dom = $(document).find("##{data.domid}")
          $dom.find('p.desc').hide()
          $dom.find('p.contents').show()
          $dom.find('p.contents').html(content)
          $dom.find('.btn-toggle').text('Close')

        ## Request Add Star

        ## Receive Add Star

        ###
        # Comment Model Events
        # prependされるためpackage
        ###

        ## Request Add Comment
        $('.submitComment').click (e)->
          $dom = $(this).parent()
          comment = $dom.find('.inputComment').val()
          if comment?
            socket.emit 'add comment',
              domid: $dom.attr('id')
              comment: comment

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
  # private methods
  ###

  # 現在パスからStream内かTopPageか判定
  inStream = ->
    return false if path is ''
    return true

  # 現在のArticlesとserverからemitされたpagesの差分を取得
  filterNewArticles = (Articles,pages,callback)->
    ids = _.map Articles, (article)->
      return article.page._id
    filtered =  _.filter pages, (article)->
      return false if _.contains ids,article.page._id
      return true
    callback(filtered)

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

    ## Comment HTML
    commentHTML = ''
    for comment in article.page.comments
      commentHTML += ViewHelper.comment(comment)

    ## Articlesのfeedの先頭よりpubDateが新しければprepend
    topPubDate  = $Articles.find('li:first').attr('pubDate')
    thisPubDate = Date.parse(variables.pubDate)

    ## トップのタイトルと追加しようとしている記事のタイトルが一緒ならPrependしない
    topTitle    = $Articles.find('li:first').find('h4').text()
    thisTitle   = variables.title

    ## Prepend
    if ( thisPubDate >= topPubDate) or (topPubDate is undefined) and (topTitle isnt thisTitle)
      $Articles.prepend( ViewHelper.mediaHead(variables) + commentHTML + ViewHelper.mediaFoot()).hide().fadeIn(500)





