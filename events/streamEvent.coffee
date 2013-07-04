###

  StreamEvent.coffee

###

module.exports.StreamEvent = (app) ->

  async  = require 'async'
  parser = require 'parse-rss'
  _      = require 'underscore'

  Stream = app.get("models").Stream
  Feed   = app.get("models").Feed
  Page   = app.get("models").Page

  ###
  # http request
  ###

  index: (req,res,next) ->
    title = req.params.stream
    Stream.findByTitle title,(err,stream)->
      if stream?
        return render(res,stream)
      else 
        Stream.create 
          title:title
          description:'description (click to edit)'
        ,(err,stream)->
          return render(res,stream)

  rss  : (req,res,next)->
    res.send "return combined rss"

  ###
  # socket.io events
  ###
  getFeedList: (socket) ->
    console.log socket

  sync : (socket,io,stream) ->
    streamname = decodeURIComponent stream
    Stream.findOne title:streamname,(err,stream)->
      socket.emit 'error' if err
      Feed.find stream:stream._id,{},{},(err,feeds)->
        feed_pages = []
        async.forEach feeds,(feed,cb)->
          parser feed.url, (articles)->
            Page.findAndUpdateByArticles articles,feed,(pages)->
              socket.emit 'error' if err
              feed_pages = feed_pages.concat pages
              cb()
        ,->
          uniqued = _.uniq feed_pages,false,(obj)->
            return obj.page.title
            
          sorted = _.sortBy(uniqued, (obj)->
            return obj.page.pubDate.getTime()).reverse()
          socket.emit 'sync completed',  sorted
          console.log "#{socket.id} is sync"

      

  changeProperty: (socket,io,data) ->
    console.log socket


###
# Private Methods
###
render = (res,stream)->
  res.render 'stream',
    title: stream.title
    description: stream.description
    feeds: stream.feeds