###

  pageSchema.coffee

  * title        [String]     ページのタイトル
  * description  [String]     見出し
  * PubDate      [Date]
  * url          [String]     元記事のurl
  * feed         [ObjectId]   親Feed
  * stargazers   [Array]      Starを付けたUserのObjectId Array

###

Mongo = require 'mongoose'
async = require 'async'
_     = require 'underscore'

PageSchema = new Mongo.Schema
  title:       { type: String, index: yes }
  description: String
  url:         String
  pubDate:     Date
  feed:        { type: Mongo.Schema.Types.ObjectId, ref: 'feeds' }
  stargazers:  [{ type: Mongo.Schema.Types.ObjectId, ref: 'users' }]

PageSchema.statics.getStarGazersById = (id,callback)->
  @findOne {_id:id},{},{ populate: 'users' },(err,page)->
    return callback err,null if err
    return callback null,page.stargazers

PageSchema.statics.findAndUpdateByArticles = (articles,feed,callback)->
  that = this
  pages = []
  async.forEach articles, (article,cb)->
    desc = sanitizeHTML(article.description) if article.description
    desc = desc.slice(0,140).concat('...') if article.description?.length > 140
    that.findOneAndUpdate
      # condition
      title:article.title
      feed : feed._id
    ,
      title      :article.title
      url        :article.link
      feed       :feed._id
      pubDate    :article.pubdate
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

###
# Private Method
###
sanitizeHTML = (str)->
  return str.replace /<(.+?)>/g, ''


exports.Page = Mongo.model 'pages', PageSchema
