###

  streamSchema.coffee

  * title [String] タイトル
  * description [String] ページ上部の説明
  * feeds [ObjectId] ObjectIdのArray
  * password [String] BasicAuthのパスワード

###

Mongo = require 'mongoose'

StreamSchema = new Mongo.Schema
  title:       { type: String, index: yes }
  description: String
  feeds:       [{ type: Mongo.Schema.Types.ObjectId, ref: 'feeds' }]

exports.Stream = Mongo.model 'streams', StreamSchema