###

Crowler.coffee
全FeedのCrowlerをメモリに持つ
watcher自体はurlとlastPubDateしか持たない

###

debug = require('debug')('config/crowler')

exports = module.exports = (app)->

  Watcher = require 'rss-watcher'
  Feed = app.get('models').Feed
  Page = app.get('models').Page


  # initializer
  watchingUrls = []
  Feed.find {}, (err,feeds)->
    return debug err if err
    for feed in feeds
      watchingUrls.push feed.feedUrl
      createWatcher(feed)

  # api
  add:(feed)->
    return if feed.feedUrl in watchingUrls
    createWatcher(feed)

createWatcher = (feed)->
  watcher = new Watcher(feed.feedUrl)
  watcher.on 'new article',(article)->
    debug("new article on #{feed.title}")
    Page.updateOne article,feed,(err)->
      return debug err if err
      app.get('emitter').emit 'new article',
        article:article
        feed:feed

  watcher.run (err,articles)->
    return debug err if err
    for article in articles
      Page.updateOne article,feed,(err)->
        return debug err if err


