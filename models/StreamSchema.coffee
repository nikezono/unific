###

  streamSchema.coffee

  * title       [String] タイトル
  * description [String] ページ上部の説明
  * feeds       [ObjectId] ObjectIdのArray-購読リスト
  * streams     [ObjectId] ObjectIdのArray-購読リスト

###

Mongo = require 'mongoose'

StreamSchema = new Mongo.Schema
  title:       { type: String, unique: yes ,index: yes }
  description: String
  articles :   Mongo.Schema.Types.Mixed
  feeds:       [{ type: Mongo.Schema.Types.ObjectId, ref: 'feeds' }]
  streams:     [{ type: Mongo.Schema.Types.ObjectId, ref: 'streams' }]

# find-by-name
StreamSchema.statics.findByTitle = (title, callback) ->
  @find title: new RegExp(title), {}, {}, (err, stream) ->
    console.error err if err
    return callback err, stream

# find-by-feed-id
StreamSchema.statics.findBySubscribedFeedId = (feedId,callback)->
  @find
    feeds:feedId
  ,(err,streams)->
    callback err,streams


exports.Stream = Mongo.model 'streams', StreamSchema
