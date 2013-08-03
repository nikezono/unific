###

  ioRoutes.coffee
   socket.ioのイベントハンドラを定義する
   PrependされるArticleのDomにbindされるイベント（コメント,Star,Read More...)は、
   prependされるたび呼ばれる

###

root = exports ? this
root.routes = (socket) ->

  attachSingleEvent: ->

    ### Alert Error ###
    socket.on 'error', -> showFade $SomethingWrong

    ### HomeEvent ###
    $GoButton.click                        -> HomeEvent.goStream()

    ### StreamEvent ###
    $FindFeedButton.click                  -> StreamEvent.requestFindFeed socket
    socket.on 'found feed', (err,response) -> StreamEvent.receivedFoundFeed err,response

    socket.on 'sync completed',    (pages) -> StreamEvent.syncArticles pages
   
    ### DomEvents ###
    $UsageButton.click                     -> DomEvent.pushedUsage()

    $InputImage.change                 (e) -> DomEvent.requestUploadImage e, socket
    socket.on 'bg uploaded',  (image_path) -> DomEvent.receivedUploadImage image_path

    $ClearBackground.click                 -> DomEvent.requestClearBg()
    socket.on 'bg cleared',                -> DomEvent.receivedClearBg()

    $InputDesc.keyup                       -> DomEvent.requestChangeDesc socket
    socket.on 'desc changed',       (data) -> DomEvent.receivedChangeDesc data

    ### FeedEvent ###
    $EditFeedButton.click                  -> FeedEvent.requestFeedList socket
    socket.on 'got feed_list',      (list) -> FeedEvent.receivedFeedList list

    $ApplyEditFeed.click                   -> FeedEvent.requestEditFeedList socket
    socket.on 'edit completed',            -> FeedEvent.receivedEditFeedList socket

    $AddFeedButton.click                   -> FeedEvent.requestAddFeed socket
    socket.on 'add-feed succeed',          -> FeedEvent.receivedAddFeed()

    ### PageEvent(socket.io) ###
    socket.on 'star added',         (data) -> PageEvent.receivedAddStar data,socket
    socket.on 'star deleted',       (data) -> PageEvent.receivedDeleteStar data,socket

    socket.on 'comment added',      (data) -> PageEvent.receivedAddComment data

  ### PageEvent(jQuery) ###
  attachDomEvent:                   ($dom) ->
    configureFancyBox $dom
    $dom.find('.read-more').click          -> PageEvent.requestReadMore $dom,socket
    $dom.find('.submitComment').click      -> PageEvent.requestSubmitComment $dom,socket
    $dom.find('.starredButton').click      -> PageEvent.requestChangeStar $dom,socket
