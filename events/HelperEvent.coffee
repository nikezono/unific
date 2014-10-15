###

  HelperEvent.coffee
  なんか切り分けできてないやつ

###

module.exports.HelperEvent = (app) ->

  finder = require 'find-rss'
  finder.setOptions
    favicon:true
    getDetail:true
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

  # Streamが購読しうるモデル(現在Feed/Streamの二種)のdocObjectを判別する
  detectCandidateType:(document,callback)->
    async.parallel [(cb)->
      Stream.findById document._id,(err,streams)->
        return cb err,null if err
        return cb null,null if _.isEmpty streams
        callback null,"stream"
    ,(cb)->
      Feed.findById document._id,(err,feeds)->
        return cb err,null if err
        if _.isEmpty feeds
          return cb null,"rss" if document.url
          return cb null,null
        cb null,"feed"
    ],(err,result)->
      return callback err,null if err
      return callback null,_.without(result,null)[0]

  # find feed or stream
  findFeed:(req,res) ->
    streamName = decodeURIComponent req.query.stream
    Stream.findOne {title: streamName},(err,stream)=>
      return @httpError err if err

      query = req.query.query

      # URLかつunificのURLではない場合
      if (query.match /^https?/) and (query.indexOf("www.unific.net") == -1 )
        finder query, (err,candidates)=>
          return @httpError err,res if err

          # Candidatesの中で既にインスタンスがあるものは置き換え
          resArray = []
          async.forEach candidates,(candidate,cb)->
            Feed.findOne
              url : candidate.url
            ,(err,feed)->
              if err or not feed
                candidate.subscribed = false
                resArray.push candidate
                return cb()
              else
                obj = feed.toObject() # 置き換え
                obj.subscribed = (stream.feeds.indexOf(feed._id) > -1)
                debug "#{obj.title} is Subscribed #{obj.subscribed} by #{streamName}"
                resArray.push obj
                return cb()
          ,->
            return res.json resArray

      # @todo ストリーム検索/フィード検索(キーワード検索)
      else
        Stream.findByTitle query,(err,streams)->
          return @httpError err,res if err
          resArray = []
          for candidate in streams
            continue if candidate._id.toString() is stream._id.toString()
            obj = candidate.toObject()
            obj.subscribed = (stream.streams.indexOf(candidate._id) > -1)
            debug "#{obj.title} is Subscribed #{obj.subscribed} by #{streamName}"
            resArray.push obj
          return res.json resArray

    # @todo ページ送り
    # @todo 時間かかりすぎ？
  getArticlesByStreamWithLimit:(streamName,limit,callback)->
    streamName = decodeURIComponent streamName
    Stream.findOne({title:streamName})
    .exec (err,stream)=>
      return callback err,null if err

      # 全フィードリストを自身と子要素/孫要素全てからunionする
      @getRecursiveAllFeedList stream,(err,feedList)->
        return callback err,null if err
        return callback null,[] if _.isEmpty feedList
        articles = []

        # 各フィードから記事を取得してarticlesに詰める
        async.forEach Object.keys(feedList),(streamTitle,cb)->
          Feed.find
            _id:
              $in:feedList[streamTitle]
          .populate
            path:'pages'
            limit: limit
            sort:
              pubDate:-1
          .exec (err,feeds)->
            return cb err if err
            for feed in feeds
              continue if not feed.pages

              # 要らない要素削減1#ページのIDをFEEDから削る
              feedObj = feed.toObject()
              omittedFeed = _.omit feedObj,"pages"
              omittedFeed.title = "#{omittedFeed.title}"
              if stream.title isnt streamTitle
                omittedFeed.title += " by #{streamTitle}"

              for page in feed.pages
                articles.push {feed:omittedFeed,page:page}

            cb()
        ,->
          # 記事全体の時間別ソート
          articles.sort (a,b)->
            b.page.pubDate - a.page.pubDate

          # 要らない要素削減2#全体の件数を上限100にする
          if(articles.length > 100)
            articles = articles.slice(0,100)

          return callback null,articles

  # 再帰的に全購読ストリームのフィードリストを合体させる
  # @param [stream]
  # @return [Object] Streamタイトル:Feedタイトル（パンくず)
  getRecursiveAllFeedList:(queryStream,callback)->
    Stream.findOne({_id:queryStream._id}).populate('streams').exec (err,stream)=>
      return callback err,null if err
      feedList = {}
      feedList["#{stream.title}"] = stream.feeds
      async.forEach stream.streams, (subStream,cb)=>
        @getRecursiveAllFeedList subStream,(err,subFeedList) ->
          return debug err if err
          feedList = _.extend feedList,subFeedList
          cb()
      ,->
        callback null,feedList

