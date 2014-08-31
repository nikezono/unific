###

Crowler.coffee
全FeedのCrowlerをメモリに持つ
watcher自体はurlとlastPubDateしか持たない

###

debug = require('debug')('config/crowler')
_    = require 'underscore'
Watcher = require 'rss-watcher'

exports = module.exports = (app)->

  Feed = app.get('models').Feed
  Page = app.get('models').Page

  watchingUrls : []

  # api
  addToSet:(feed)->
    return if feed.url in @watchingUrls
    @createWatcher(feed)
    @watchingUrls.push feed.url

  createWatcher : (feed)->
    watcher = new Watcher(feed.url)
    watcher.set
      interval:60*3 # @todo frequencymoduleがオカシイ
    watcher.on 'new article',(article)=>
      debug("new article on #{feed.title}")
      @updateOne article,feed,(page)=>
        app.get('emitter').emit 'new article',
          page:page
          feed:feed

    watcher.run (err,articles)=>
      return debug err if err
      for article in articles
        @updateOne article,feed,(page)=>
          app.get('emitter').emit 'new article',
            page:page
            feed:feed

  updateOne:(article,feed,callback)->
    Page.updateOneWithFeed article,feed,(err,page)->
      return debug err if err
      feed.pages.addToSet page
      feed.save ->
        callback page if callback

  initialize : ->
    Feed.find {}, (err,feeds)=>
      return debug err if err
      for feed in feeds
        @createWatcher(feed)
        @watchingUrls.push feed.url


