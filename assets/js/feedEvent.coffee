###
#
# feedEvent.coffee
# feedモデルに関連するeventの定義
#
###

root = exports ? this
root.FeedEvent =

  requestFeedList     : (socket) ->
    socket.emit 'get feed_list', path
  
  receivedFeedList    : (list)   ->
    if list?
      $FeedList.html('')
      for feed in list
        $FeedList.append ViewHelper.feedList(feed)
      $EditFeedModal.modal()
    else
      console.log "no feed" # @todo alert

  requestEditFeedList : (socket) ->
    urls = []
    $FeedList.find(":checkbox:checked").each ->
      urls.push $(this).attr('url')
    socket.emit 'edit feed_list',
      urls: urls
      stream:path

  receivedEditFeedList : (socket)->
    showFade $EdittedList
    window.Articles = []
    $Articles.html('')
    console.log 'sync by feed_list editted'
    socket.emit 'sync stream',
      stream:path
      latest:latestPubDate()

  requestAddFeed : (socket) ->
    urls  = []
    $CandidatesList.find(":checkbox:checked").each ->
      urls.push
        url:$(this).val()
        title:$(this).attr('title')
        siteurl:$(this).attr('siteurl')
        favicon:$(this).parent().find('img').attr('src')
    unless urls.length is 0
      socket.emit 'add feed',
        urls  :urls
        stream:path

  receivedAddFeed : (socket)->
    showFade $NewFeed
    window.Articles = []
    $Articles.html('')
    console.log 'sync by add feed'
    socket.emit 'sync stream',
      stream:path
      latest:latestPubDate()
