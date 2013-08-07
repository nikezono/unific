###

  feedSchema.coffee

  * title    [String]    フィードのタイトル
  * url      [String]    フィードのURL
  * site     [String]    サイトのURL
  * updated  [Date]      アップデート日
  * favicon  [String]    faviconのurl
  * pages    [ObjectId]  PageオブジェクトのArray
  * active   [Boolean]   現在リストに入っているか（削除されてもinactiveになるだけ)
  * stream   [ObjectId]  親Stream

###

Mongo = require 'mongoose'

FeedSchema = new Mongo.Schema
  title:       { type: String, index: yes }
  url:         String
  site:        String
  favicon:     String
  pages:       [{ type: Mongo.Schema.Types.ObjectId, ref: 'pages' }]
  alive:       Boolean
  stream:      { type: Mongo.Schema.Types.ObjectId, ref: 'streams' }

exports.Feed = Mongo.model 'feeds', FeedSchema