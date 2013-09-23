###

  FeedEvent.coffee

###

module.exports.FeedEvent = (app) ->

  async  = require 'async'
  _      = require 'underscore'

  Stream = app.get("models").Stream
  Feed   = app.get("models").Feed

  updater = (app.get 'helper').updateStream(app)

  ###
  # socket.io events
  ###

  addFeed:(socket,io,data) -> 
    streamname = decodeURIComponent data.stream
    Stream.findByTitle streamname, (err,stream)->
      return socket.emit 'error' if err
      async.forEach data.urls, (param,cb)->
        Feed.findOneAndUpdate
          title : param.title
          url   : param.url
          stream: stream._id
        , 
          title      : param.title
          feed_url   : param.url
          favicon_url:param.favicon
          site_url   : param.siteurl
        , upsert: true,(err,feed)->
          if err
            console.error err
            return cb()

          # 親リストに追加
          feed.streams.push stream._id
          feed.save()
          # 子リストに追加
          stream.feeds.push feed._id
          stream.save()

          return cb()
      ,->
        console.info "Stream:#{stream.title} add feed"

        # @todo リファクタリング iss#41
        updater.update stream.title,false, (articles)->
          io.sockets.to(data.stream).emit 'add-feed succeed'


  editFeedList:(socket,io,data) ->
    console.info 'editted feed-list by #{socket.id}'
    streamname = decodeURIComponent data.stream
    Stream.findOne title:
    Stream.getFeedsById stream._id,(err,feeds)->
      return socket.emit 'error' if err
      async.forEach feeds, (feed,cb)->
        # チェックボックスに✓されていないurlの場合Arrayからwithoutする
        unless feed.url in data.urls
          feed.streams = _.without(feed.streams,stream._id)
          feed.save()
          stream.feeds = _.without(stream.feeds,feed._id)
          stream.save()
        cb()
      , ->
        console.info "Stream:#{stream.title} edit feed"

        # @todo リファクタリング iss#41
        updater.update streamname,false,(articles)->
          io.sockets.to(data.stream).emit 'edit completed'



