###

  feedSchema.coffee

  * title    [String]    フィードのタイトル
  * url [String]    フィードのURL
  * updated  [Date]      アップデート日
  * pages    [ObjectId]  PageオブジェクトのArray
  * stream   [ObjectId]  親Stream

###

Mongo = require 'mongoose'

FeedSchema = new Mongo.Schema
  title:       { type: String, index: yes }
  url:         String
  pages:       [{ type: Mongo.Schema.Types.ObjectId, ref: 'pages' }]
  stream:      { type: Mongo.Schema.Types.ObjectId, ref: 'streams' }

exports.Feed = Mongo.model 'feeds', FeedSchema