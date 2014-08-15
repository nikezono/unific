###

  streamSchema.coffee

  * title [String] タイトル
  * description [String] ページ上部の説明
  * feeds [ObjectId] ObjectIdのArray

###

Mongo = require 'mongoose'

StreamSchema = new Mongo.Schema
  title:       { type: String, unique: yes ,index: yes }
  description: String
  articles :   Mongo.Schema.Types.Mixed
  feeds:       [{ type: Mongo.Schema.Types.ObjectId, ref: 'feeds' }]

# find-by-name
StreamSchema.statics.findByTitle = (title, callback) ->
  @findOne title: title, {}, {}, (err, stream) ->
    console.error err if err
    return callback err, stream


exports.Stream = Mongo.model 'streams', StreamSchema
