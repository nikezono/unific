###

  feedSchema.coffee

  * title    [String]    フィードのタイトル
  * url      [String]    フィードのURL
  * site     [String]    サイトのURL
  * favicon  [String]    faviconのurl
  * pages    [ObjectId]  PageオブジェクトのArray
  * streams  [ObjectId]  親Streams

###

Mongo = require 'mongoose'

FeedSchema = new Mongo.Schema
  title:       { type: String, index: yes }
  site_url:    String
  feed_url:    String
  favicon_url: String
  pages:       [{ type: Mongo.Schema.Types.ObjectId, ref: 'pages' }]
  streams:     [{ type: Mongo.Schema.Types.ObjectId, ref: 'streams' }]

exports.Feed = Mongo.model 'feeds', FeedSchema