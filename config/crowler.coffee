###

Crowler.coffee
全FeedのCrowlerをメモリに持つ
watcher自体はurlとlastPubDateしか持たない

###

debug = require('debug')('config/crowler')

exports = module.exports = (app)->

  Watcher = require 'rss-watcher'
  Feed = app.get('models').Feed


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
    feed.newArticle article
  watcher.run (err,articles)->
    return debug err if err
    feed.newArticles articles


