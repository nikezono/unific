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
      feedUrl   : data.feed.url
      favicon   : data.favicon
      site      : data.siteurl
    , upsert    : true ,(err,feed)->
      if err
        debug err
        return HelperEvent.error(err,socket)

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

