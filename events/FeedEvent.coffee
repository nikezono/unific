###

  FeedEvent.coffee

###

debug = require('debug')('events/feed')

module.exports.FeedEvent = (app) ->

  HelperEvent = app.get('events').HelperEvent app
  Feed        = app.get('models').Feed
  Subscribe   = app.get('models').Subscribe

  createFeed:(data,socket) ->
    # update or create #
    Feed.findOneAndUpdate
      feedUrl   : data.feed.url
    ,
      title     : data.feed.title
      feedUrl   : data.feed.xmlurl
      favicon   : data.feed.favicon
      siteUrl   : data.feed.link
    , upsert    : true ,(err,feed)->
      if err
        debug err
        return HelperEvent.error(err,socket)

      # データ更新&watcher
      # @todo ここらへんかなり密になっててやばい
      crowler     = app.get('crowler')
      crowler.add feed

      if data.stream
        Subscribe.findOneAndUpdate
          feed   : feed_id
          stream : data.stream # IDではなく名前
        ,
          feed   : feed_id
          stream : data.stream
        , upsert : true,(err,sub)->
          if err
            debug err
            return HelperEvent.error(err,socket)
          return socket.emit 'lgtm'

