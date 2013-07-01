###

  pageSchema.coffee

  * title        [String]     ページのタイトル
  * description  [String]     見出し
  * url          [String]     元記事のurl
  * readable     [String]     readabilityを通したあとのhtml/text
  * starred      [Bool]       スターが付けられているか
  * comments     [ObjectId]   CommentオブジェクトのArray
  * feed         [ObjectId]   親Feed

###

Mongo = require 'mongoose'

PageSchema = new Mongo.Schema
  title:       { type: String, index: yes }
  description: String
  url:         String
  readable:    String
  starred:     Boolean
  comments:    [{ type: Mongo.Schema.Types.ObjectId, ref: 'comments' }]
  feed:        { type: Mongo.Schema.Types.ObjectId, ref: 'feeds' }

exports.Page = Mongo.model 'pages', PageSchema