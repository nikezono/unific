###

  pageSchema.coffee

  * title        [String]     ページのタイトル
  * description  [String]     見出し
  * url          [String]     元記事のurl
  * readable     [String]     readabilityを通したあとのhtml/text
  * starred      [Bool]       スターが付けられているか
  * comments     [ObjectId]   CommentオブジェクトのArray
  * feed         [ObjectId]   親Feed

###

Mongo = require 'mongoose'
async = require 'async'
_     = require 'underscore'

PageSchema = new Mongo.Schema
  title:       { type: String, index: yes }
  description: String
  url:         String
  readable:    String
  starred:     Boolean
  pubDate:     Date
  comments:    [{ type: Mongo.Schema.Types.ObjectId, ref: 'comments' }]
  feed:        { type: Mongo.Schema.Types.ObjectId, ref: 'feeds' }

PageSchema.statics.findAndUpdateByArticles = (articles,feed,callback)->
  that = this
  pages = []
  unless feed.site?
    feed.site = articles[0].meta.link if articles[0]?.meta?.link?
    feed.save()
  async.forEach articles, (article,cb)->
    desc = article.description.slice(0,140).concat('...') if article.description.length > 140
    that.findOneAndUpdate
      # condition
      title:article.title
      feed : feed._id
    ,
      title:article.title
      url  :article.link
      feed :feed._id
      pubDate:article.pubdate
      description:desc
    , upsert: true , (err,page) ->
      console.error err if err
      # CallbackにFeedもExtendさせる
      pages.push
        page: page
        feed: feed
      cb()
  ,->
    callback pages

exports.Page = Mongo.model 'pages', PageSchema