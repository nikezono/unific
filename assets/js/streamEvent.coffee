###
#
# streamEvent.coffee
# streamモデルに関連するイベントを定義する
#
###

root = exports ? this
root.StreamEvent = 

  syncArticles: (pages)->

    #更新昇順
    sorted = _.sortBy pages, (obj)->
      return Date.parse obj.page.pubDate

    $NoFeed.hide() unless pages.length is 0
    appended = false
    for article in sorted
      appended = appendArticle article
    showFade $NewArticle if appended
      

  requestFindFeed : (socket)->
    $NoFeedIsFound.hide()
    socket.emit 'find feed', $FindFeedInput.val()


  receivedFoundFeed : (error,response)->
    $NoFeedIsFound.show() if error?
    if response.candidates?
      $CandidatesList.html('')
      for candidate in response.candidates
        candidate.sitetitle = "#{candidate.sitename} - #{candidate.title or 'feed'}"
        candidate.siteurl   = response.url
        $CandidatesList.append ViewHelper.candCheckbox(candidate)
      $CandidatesModal.modal()


# 記事の追加
# @return [Boolean] 追加されたらtrue されなければfalse
appendArticle = (article)-> 
  variables = 
    title       : article.page.title
    id          : article.page._id
    comments    : article.page.comments
    description : article.page.description
    pubDate     : article.page.pubDate
    url         : article.page.url
    sitename    : article.feed.title
    favicon     : article.feed.favicon
    siteurl     : article.feed.site
    starred     : article.page.starred

  ## Comment HTML
  commentHTML = ''
  for comment in article.page.comments
    commentHTML += ViewHelper.comment(comment)

  ## 同名記事はPrependしない
  thisTitle      = variables.title
  duplicate      = thisTitle in Articles

  #console.log "#{not latestPubDate()} , #{not duplicate}"

  ## 記事が存在しないか、重複していなければ、Prepend
  if not latestPubDate()? or not duplicate
    $Articles.prepend( ViewHelper.mediaHead(variables) + commentHTML + ViewHelper.mediaFoot(variables)).hide().fadeIn(500)
    $dom = $Articles.find("##{variables.id}")
    router.attachDomEvent $dom
    Articles.push thisTitle
    return true
  else
    return false
