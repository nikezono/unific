###

  feedSchema.coffee

  * title    [String]    フィードのタイトル
  * feedUrl  [String]    フィードのURL
  * siteUrl  [String]    サイトのURL
  * updated  [Date]      アップデート日
  * favicon  [String]    faviconのurl
  * pages    [ObjectId]  PageオブジェクトのArray

###

Mongo = require 'mongoose'

FeedSchema = new Mongo.Schema
  title:       { type: String, index: yes }
  sitename:    String
  url:         String
  siteUrl:     String
  favicon:     String
  pages:       [{ type: Mongo.Schema.Types.ObjectId, ref: 'pages', default:[] }]

exports.Feed = Mongo.model 'feeds', FeedSchema
