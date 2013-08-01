###
#
# pageEvent.coffee
# pageモデルに関連するeventの定義
#
###

root = exports ? this
root.PageEvent =

  receivedAddStar : (data,socket) ->
    $dom = $(document).find("##{data.domid}")
    $dom.find('span.starred').html(ViewHelper.starredIcon(true))
    $dom.find('span.starButton').html(ViewHelper.starredButton(true))
    router.attachDomEvent($dom)

  receivedDeleteStar : (data,socket) ->
    $dom = $(document).find("##{data.domid}")
    $dom.find('span.starred').html(ViewHelper.starredIcon(false))
    $dom.find('span.starButton').html(ViewHelper.starredButton(false))
    router.attachDomEvent($dom)

  receivedAddComment : (data) ->
    $dom = $(document).find("##{data.domid}")
    $dom.find('.comments').html('')
    for comment in data.comments
      $dom.find('.comments').append("<blockquote>#{comment}</blockquote>")
    $dom.find('.commentsLength').text(data.comments.length)

  requestReadMore :($dom,socket)->
    $dom.find('a.fancy').click()

  requestSubmitComment :($dom,socket)->
    comment = $dom.find('.inputComment').val()
    if comment?
      socket.emit 'add comment',
        domid: $dom.attr('id')
        comment:comment
        stream :path

  requestChangeStar :($dom,socket)->
    console.log 'change'
    act  = $dom.find('button.starredButton').attr('value')
    if act is 'star'
      socket.emit 'add star',
        domid: $dom.attr('id')
    else if act is 'unstar'
      socket.emit 'delete star',
        domid: $dom.attr('id')
        stream:path