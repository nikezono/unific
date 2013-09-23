###

  streamSchema.coffee

  * title       [String] タイトル
  * description [String] ページ上部の説明
  * feeds       [ObjectId] ObjectIdのArray
  * creator     [ObjectId]
  * subscribers [ObjectId]

###

Mongo = require 'mongoose'

StreamSchema = new Mongo.Schema
  title:       { type: String, unique: yes ,index: yes }
  description: String
  articles:    Mongo.Schema.Types.Mixed
  feeds:       [{ type: Mongo.Schema.Types.ObjectId, ref: 'feeds' }]
  creator:      { type: Mongo.Schema.Types.ObjectId, ref: 'users' }
  subscribers: [{ type: Mongo.Schema.Types.ObjectId, ref: 'users' }]

StreamSchema.statics.getFeedsById = (id,callback)->
  @findOne {_id:id},{},{ populate: 'feeds' },(err,stream)->
    return callback err,null if err
    return callback null,stream.feeds

StreamSchema.statics.getFeedsByTitle = (title,callback)->
  @findOne {title:title},{},{ populate: 'feeds' },(err,stream)->
    return callback err,null if err
    return callback null,stream.feeds

StreamSchema.statics.getSubScribersById = (id,callback)->
  @findOne {_id:id},{},{ populate: 'users' },(err,stream)->
    return callback err,null if err
    return callback null,stream.subscribers

StreamSchema.static.getCreatorById = (id,callback)->
  @findOne {_id:id},{},{ populate: 'users' },(err,stream)->
    return callback err,null if err
    return callback null,stream.creator

# find-by-name
# @todo 要らんので依存削除して修正
StreamSchema.statics.findByTitle = (title, callback) ->
  @findOne title: title, {}, {}, (err, stream) ->
    console.error err if err
    return callback err, stream


exports.Stream = Mongo.model 'streams', StreamSchema