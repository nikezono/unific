###

  pageSchema.coffee

  * title        [String]     ページのタイトル
  * description  [String]     見出し
  * url          [String]     元記事のurl
  * starred      [Number]       スターが付けられているか
  * feed         [ObjectId]   親Feed

###

Mongo = require 'mongoose'
async = require 'async'
_     = require 'underscore'

debug = require('debug')('models/page')

PageSchema = new Mongo.Schema
  title:       { type: String, index: yes }
  description: String
  url:         String
  starred:     { type: Number, default: 0 }
  pubDate:     Date
  comments:    [String]
  feed:        { type: Mongo.Schema.Types.ObjectId, ref: 'feeds' }

PageSchema.statics.updateOneWithFeed = (article,feed,callback)->
  @findOneAndUpdate
    title: article.title
    feed : feed._id
  ,
    title      :article.title
    url        :article.link
    feed       :feed._id
    pubDate    :article.pubdate
    description:article.description
  , upsert: true , (err,page) ->
    if err
      debug(err)
      return callback err,null
    return callback null,page

exports.Page = Mongo.model 'pages', PageSchema
