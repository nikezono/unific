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

  # バッチ処理によるアップデート
  # 引数無し -> 非同期実行
  # @streamname バッチ処理結果を受け取りたいstreamの名前
  # @all        全ストリームにアップデートをかけるか。
  #             falseの場合streamnameに指定されたstreamのみupdate
  # @callback (articles) コールバック関数
  update : (streamname,all,callback)->
    all = true unless all?
    that = @
    console.info "Batch Processing Start"
    if not all and streamname
      Stream.findOne title:streamname, (err,stream)->
        console.log "Only #{streamname} is updating"
        that.findArticlesByStream stream,'',(err,merged)->
          console.error err unless _.isEmpty(err)
          that.manageArticles merged,(err,articles)->
            console.error err if err?

            stream.articles = articles
            stream.markModified('articles')
            stream.save()
            console.log "#{streamname} is Updated."
            return callback articles if callback?
        ,->
          return console.info "Batch Processing is Completed."

    else 
      Stream.find {}, (err,streams) ->
        console.error if err?
        async.forEach streams, (stream,cb)->
          that.findArticlesByStream stream,'',(errors,merged)->
            console.error errors unless _.isEmpty(errors)
            console.log "stream #{stream.title} articles merged"
            unless _.isEmpty(merged)
              that.manageArticles merged,(err,articles)->
                console.error err unless _.isEmpty(err)
                stream.articles = articles
                stream.markModified('articles')
                stream.save()
                callback articles if streamname is stream.title and callback?
                return cb()
            else
              return cb()
        ,->
          return console.info "Batch Processing is Completed."


  # ストリームからArticlesを再帰的に探してきてマージする
  # @todo 重い
  # @stream      [Stream] ストリームObject
  # @parent      [String](Optional) 親ストリームの名前（再帰）
  # @callback    [Function](err,feeds)  マージされたフィード
  findArticlesByStream: (stream,parent,callback)->
    console.info "#{stream.title} is updating.parent:#{parent}"
    that = @
    # Feedの検索
    Feed.find 
      stream:stream._id
      alive :true
    ,{},{},(err,feeds)->
      if err? or _.isEmpty(feeds)
        return callback null,[] if _.isEmpty(feeds)
      else
        feed_pages = []
        # 各ArticleのMerge
        errors = []
        
        async.forEach feeds,(feed,cb)->
          console.info "feed #{feed.title} is updating"
          urlObj = url.parse(feed.url)

          # 親子関係のときobjectを返す
          if urlObj.hostname in domain
            substreamname = urlObj.pathname.split('/')[1]
            # ループ離脱（フォロー相手に自分が含まれていれば除く)
            if substreamname is parent
              console.info "#{stream.title} follows #{parent}."
              return cb()
            else
              Stream.findOne {title:substreamname}, (err,substream)->
                if err?
                  console.error err
                  return cb()
                else
                  console.info "#{stream.title} follows #{substream.title}. Recursive Strategy Start."
                  that.findArticlesByStream substream,stream.title,(err,pages)->
                    errors = errors.concat err if _.isEmpty(err)
                    feed_pages = feed_pages.concat pages
                    return cb()

          else
            console.log "外部サイト取得:#{feed.title} url:#{feed.url}"

            # 外部サイト
            parser feed.url, (err,articles)->
              console.log "#{feed.title} is returned. error:#{err} articles:#{articles?}. articles?.length?:#{articles?.length?}"
              unless err? 
                console.error err
                return cb()
              if articles?.length?
                console.info "#{feed.title} 取得."
                Page.findAndUpdateByArticles articles,feed,(pages)->
                  feed_pages = feed_pages.concat pages
                  return cb()
              else
                console.info "no error but #{feed.title} missed."
                return cb()
        ,->
          console.log "stream #{stream.title} is find&parsed"
          return callback errors, feed_pages

  # マージされた記事の整形
  # スター付き記事全てととスター無し記事最新50件をマージ
  manageArticles : (articles,callback)->

    # ヌル記事の削除
    delnulled = _.filter articles,(obj)->
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
      return callback err,res
