###

  StreamEvent.coffee

###

module.exports.StreamEvent = (app) ->

  async  = require 'async'
  RSS    = require 'rss'
  _      = require 'underscore'
  url    = require 'url'

  Stream = app.get("models").Stream
  Feed   = app.get("models").Feed
  Page   = app.get("models").Page

  domain = app.get 'domain'

  ###
  # http request
  ###

  index: (req,res,next) ->
    title = req.params.stream
    Stream.findByTitle title,(err,stream)->
      if stream?
        return render(req,res,stream)
      else
        Stream.create 
          title:title
          description:'description (click to edit)'
        ,(err,stream)->
          return render(req,res,stream)

  rss  : (req,res,next) ->
    streamname = req.params.stream
    @getDiff streamname,undefined, (err,articles)->
      return socket.emit 'error' if err
      # lets create an rss feed 
      feed = new RSS
        title: "#{streamname} - Unific"
        description: "Generated By Unific"
        feed_url: "http://unific.net/#{streamname}rss"
        site_url: "http://unific.net/#{streamname}"
        author: "Unific"
        webMaster: "nikezono"
        copyright: "2013 nikezono.net"
        pubDate: articles[0].page.pubDate
      
      async.forEach articles,(article,cb)->
        # loop over data and add to feed 
        feed.item
          title: article.page.title
          description: article.page.description
          url: article.page.url
          author: article.feed.title # optional - defaults to feed author property
          date: article.page.pubDate
        cb()
      ,->
        xml = feed.xml()
        res.set
          "Content-Type": "text/xml"
        res.send xml

  ###
  # socket.io events
  ###
  getFeedList: (socket,stream) ->
    streamname = decodeURIComponent stream
    Stream.findOne title:streamname,(err,stream)->
      return socket.emit 'error' if err
      Feed.find stream:stream._id,{},{},(err,feeds)->
        return socket.emit 'error' if err or (feeds.length is 0)
        socket.emit 'got feed_list', feeds

  sync : (socket,data) ->
    console.info "socket #{socket.id} request sync. stream:#{data.stream} latest:#{data.latest}"
    streamname = decodeURIComponent data.stream
    @getDiff streamname,data.latest, (err,articles)->
      return socket.emit 'error' if err
      # Sync Completed
      socket.emit 'sync completed',  articles
      console.log "#{socket.id} is sync"

      

  changeDesc: (socket,io,data) ->
    streamname = decodeURIComponent data.stream
    Stream.findOne title:streamname, (err,stream)->
      return socket.emit 'error' if err
      stream.description = data.text
      stream.save()
      socket.broadcast.to(data.stream).emit 'desc changed',
        text:data.text


  ###
  # Helper Methods
  ###

  # ストリームから最新記事Objectを取得し、差分を返却する
  # @streamname  [String] ストリームの名前
  # @latest      [Number] clientの最新記事のpubDate(Unix Time)
  # @callback    [Function](err,feeds) 差分
  getDiff: (streamname,latest,callback) ->
    Stream.findOne title:streamname,(err,stream)->
      return callback err,null if err?
      return callback null,stream.articles if not latest?
      articles = _.filter stream.articles,(article)->
        #console.log "#{article.page.pubDate.getTime()} > #{latest}?"
        return article.page.pubDate.getTime() > latest
      callback null,articles

###
# Private Methods
###
render = (req,res,stream)->
  res.render 'stream',
    title: stream.title
    user : req.user
    description: stream.description
    background:stream.background
    feeds: stream.feeds
    rss  : "/#{stream.title}/rss"