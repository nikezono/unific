###

  HelperEvent.coffee
  なんか切り分けできてないやつ

###

module.exports.HelperEvent = (app) ->

  finder = require 'find-rss'
  async  = require 'async'
  _      = require 'underscore'
  debug = require('debug')('events/helper')

  Stream = app.get('models').Stream
  Feed   = app.get('models').Feed
  Page   = app.get('models').Page

  # 汎用socket.ioエラー
  ioError: (err,socket)->
    # @todo エラー種別判定してメッセージ変える
    debug err
    console.trace err
    return socket.emit "serverError","Error:unhandled"

  # 汎用httpエラー
  httpError: (err,res)->
    debug err
    console.trace err
    return res.send 400,"Internal Server Error"

  # find feed or stream
  findFeed:(req,res) ->
    streamName = decodeURIComponent req.query.stream
    Stream.findByTitle streamName,(err,stream)->
      return @httpError err if err

      query = req.query.query

      # URLの場合
      if query.match /^(http:\/\/|https:\/\/)/
        finder query, (err,candidates)=>
          return @httpError err,res if err

          # Candidatesの中で既にインスタンスがあるものは置き換え
          resArray = []
          async.forEach candidates,(candidate,cb)->
            Feed.findOne
              url : candidate.url
            ,(err,feed)->
              if err or not feed
                resArray.push candidate
                return cb()
              feedObj = feed.toObject() # 置き換え
              if stream.feeds.indexOf feed._id isnt -1 # フラグ
                feedObj.subscribed = true
                debug "#{candidate.title} has Subscribed by #{streamName}"
              resArray.push feedObj
              return cb()
          ,->
            return res.json resArray

      # @todo ストリーム検索/フィード検索(キーワード検索)
      # @todo not found
      else
        Stream.findByTitle query,(err,stream)->
          return @httpError err,res if err
          res.json stream

    # @todo ページ送り
  getArticlesByStreamWithLimit:(streamName,limit,callback)->
    streamName = decodeURIComponent streamName
    Stream.findOne({title:streamName})
    .populate("feeds")
    .exec (err,stream)->
      return callback err,null if err
      Feed.populate stream,
        path:'feeds.pages'
        model:Page
        options:
          limit: limit
      ,(err,stream)->
        return callback err,null if err
        articles = []
        for feed in stream.feeds
          for page in feed.pages
            articles.push {feed:feed,page:page}
        articles.sort (a,b)->
          b.page.pubDate - a.page.pubDate
        return callback null,articles
