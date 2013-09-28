###

  feedSchema.coffee

  * title       [String]    フィードのタイトル
  * feed_url    [String]    フィードのURL
  * site_url    [String]    サイトのURL
  * favicon_url [String]    faviconのurl
  * pages       [ObjectId]  PageオブジェクトのArray
  * streams     [ObjectId]  このFeedを登録しているStreams

###

Mongo = require 'mongoose'

FeedSchema = new Mongo.Schema
  title:       { type: String, index: yes }
  site_url:    String
  feed_url:    String
  favicon_url: String
  pages:       [{ type: Mongo.Schema.Types.ObjectId, ref: 'pages' }]
  streams:     [{ type: Mongo.Schema.Types.ObjectId, ref: 'streams' }]

FeedSchema.statics.getPagesById = (id,callback)->
  @findOne {_id:id},{},{ populate: 'pages' },(err,feed)->
    return callback err,null if err
    return callback null,feed.pages


exports.Feed = Mongo.model 'feeds', FeedSchema