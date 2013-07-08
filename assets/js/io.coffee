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
          $dom.find('.comments').append("<div class= 'well well-small'>#{data.comment}</div><br>")
          num = Number($dom.find('.commentsLength').text())
          $dom.find('.commentsLength').text(num+1)

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
    id          = article.page._id
    comments    = article.page.comments
    description = article.page.description
    pubDate     = article.page.pubDate
    url         = article.page.url
    sitename    = article.feed.title
    siteurl     = article.feed.site

    ## Comment HTML
    commentHTML = ''
    for comment in article.page.comments
      commentHTML += "
        <div class= 'well well-small'>#{comment}</div>"

    ## Articlesのfeedの先頭よりpubDateが新しければprepend
    topPubDate  = $('#Articles').find('li:first').attr('pubDate')
    thisPubDate = Date.parse(pubDate)
    console.log "#{thisPubDate} > #{topPubDate}"
    if ( thisPubDate > topPubDate) or (topPubDate is undefined)
      $('#Articles').prepend("
      <li class='media well' pubDate= '#{Date.parse pubDate}'>
        <div class='media-body' id='#{id}'>
          <a href=#{url}>
            <h4 class='media-heading'>#{title}   
              <a href='#{siteurl}''>
                 <small>#{sitename}</small>
              </a>
            </h4>
          </a>
          <i class='icon-pencil'> #{moment(article.page.pubDate).fromNow()}</i>
          <i class='icon-comments-alt'>  Comments(<num class='commentsLength'>#{comments.length}</num>) </i>
          <span class= 'starred'>
            <i class='icon-star-empty'> starred</i>
          </span>
          <br><br>
          <p class ='desc'>#{description}</p>
          <p class='contents'></p>
          <div class='comments'>
          " + commentHTML + "
          </div>
          <input type='text' placeholder='Comment...' class='inputComment input-medium search-query'>
          <button  class='btn submitComment'><i class='icon-comment-alt'></i>  Comment</button>
          <button class='btn btn-toggle'><i class='icon-hand-right'></i>  Read More</button>
          <button class='btn btn-info'><i class='icon-star'></i>  Star</button>
        </div>
      </li>").hide().fadeIn(500)







