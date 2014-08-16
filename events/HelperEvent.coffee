###

  HelperEvent.coffee
  なんか切り分けできてないやつ

###

module.exports.HelperEvent = (app) ->

  finder = require 'find-rss'
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
    query = req.query.query
    if query.match /^(http:\/\/|https:\/\/)/
      finder query, (err,candidates)=>
        return @httpError err,res if err
        res.json candidates

    # @todo ストリーム検索/フィード検索(キーワード検索)
    # @todo not found
    else
      Stream.findByTitle query,(err,stream)->
        return @httpError err,res if err
        res.json stream

  # @todo ページ送り
  getPagesByStreamWithLimit:(streamName,limit,callback)->
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
        pages = []
        for feed in stream.feeds
          pages = pages.concat feed.pages
        pages.sort (a,b)->
          b.pubDate - a.pubDate
        return callback null,pages
