###

  FeedEvent.coffee

###

module.exports.FeedEvent = (app) ->

  combiner = require('combine-rss').combiner()  
  async    = require 'async'

  Stream = app.get("models").Stream
  Feed   = app.get("models").Feed

  ###
  # socket.io events
  ###

  addFeed:(socket,data) -> 
    streamname = decodeURIComponent data.stream
    Stream.findByTitle streamname, (err,stream)->
      socket.emit 'error' if err
      async.forEach data.urls, (param,cb)->
        Feed.findOneAndUpdate
          title : param.title
          url   : param.url
          stream: stream._id
        ,
          title : param.title
          url   : param.url
          stream: stream._id
          alive : true
          site  : param.siteurl
        , upsert: true,(err,feed)->
          console.error err if err
          cb()
      ,->
        console.info "Stream:#{stream.title} add feed"
        socket.emit 'add-feed succeed'


  deleteFeed:(socket,data) ->
    console.log data

  activeFeed:(socket,data) ->
    console.log data

  inactiveFeed:(socket,data) ->
    console.log data