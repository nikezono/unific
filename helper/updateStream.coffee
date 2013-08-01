###

  updateStream.coffee
  streamのfeedをmergeしてupdateするバッチ処理

###

module.exports.updateStream = (app) ->

  async  = require 'async'
  parser = require 'parse-rss'
  RSS    = require 'rss'
  _      = require 'underscore'
  url    = require 'url'

  Stream = app.get("models").Stream
  Feed   = app.get("models").Feed
  Page   = app.get("models").Page

  domain = app.get 'domain'

  update : ->
    that = @
    console.info "Batch Processing Start"
    Stream.find {}, (err,streams) ->
      console.error if err?
      async.forEach streams, (stream,cb)->
        that.findArticlesByStream stream,'',(err,articles)->
          return console.error err if err?
          stream.articles = articles
          stream.markModified('articles')
          stream.save()

  # ストリームからArticlesを再帰的に探してきてマージする
  # @todo 重い
  # @stream      [Stream] ストリームObject
  # @parent      [String](Optional) 親ストリームの名前（再帰）
  # @callback    [Function](err,feeds)  マージされたフィード
  findArticlesByStream: (stream,parent,callback)->
    that = @
    # Feedの検索
    Feed.find 
      stream:stream._id
      alive :true
    ,{},{},(err,feeds)->
      feed_pages = []
      # 各ArticleのMerge
      async.forEach feeds,(feed,cb)->
        urlObj = url.parse(feed.url)

        # 親子関係のときobjectを返す
        if urlObj.hostname in domain
          substreamname = urlObj.pathname.split('/')[1]
          # ループ離脱（フォロー相手に自分が含まれていれば除く)
          if substreamname is parent
            cb()
          else
            that.findArticlesByStream substreamname,stream.title,(err,pages)->
              feed_pages = feed_pages.concat pages
              cb()
        else
          # 外部サイト
          parser feed.url, (articles)->
            Page.findAndUpdateByArticles articles,feed,(pages)->
              return callback err,null if err
              feed_pages = feed_pages.concat pages
              cb()
      ,->
        #ヌル記事の削除
        delnulled = _.filter feed_pages,(obj)->
          return false unless obj.page?
          return true

        # uniqued
        uniqued = _.uniq delnulled,false,(obj)->
          return obj.page.link or obj.page.title or obj.page.description or obj.page.url

        async.parallel [(cb)->

          ## スター付きの記事を抽出
          starred = _.filter uniqued, (obj)->
            return obj.page.starred is true
          cb(null,starred)

        ,(cb)->

          # スター無し
          unstarred = _.filter uniqued, (obj)->
            return obj.page.starred is false

          # sorted(更新昇順)
          sorted = _.sortBy unstarred, (obj)->
            return obj.page.pubDate.getTime()

          # limited(昇順50件)
          limited = sorted.slice sorted.length-50 if sorted.length > 50
          cb(null,limited or sorted)

        ],(err,results)->
          merged = results[0].concat(results[1])
          res  = _.sortBy merged, (obj)->
            return obj.page.pubDate.getTime()

          return callback null, res

