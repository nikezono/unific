###

  feedSchema.coffee

  * title    [String]    フィードのタイトル
  * url      [String]    フィードのURL
  * updated  [Date]      アップデート日
  * pages    [ObjectId]  PageオブジェクトのArray
  * active   [Boolean]   現在リストに入っているか（削除されてもinactiveになるだけ)
  * stream   [ObjectId]  親Stream

###

Mongo = require 'mongoose'

FeedSchema = new Mongo.Schema
  title:       { type: String, index: yes }
  url:         String
  pages:       [{ type: Mongo.Schema.Types.ObjectId, ref: 'pages' }]
  alive:       Boolean
  stream:      { type: Mongo.Schema.Types.ObjectId, ref: 'streams' }

exports.Feed = Mongo.model 'feeds', FeedSchema