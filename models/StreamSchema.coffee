###

  streamSchema.coffee

  * title [String] タイトル
  * description [String] ページ上部の説明
  * feeds [ObjectId] ObjectIdのArray
  * background [String] Background_Imageのパス(通常は,/public/images/title.filetype)
  * password [String] BasicAuthのパスワード

###

Mongo = require 'mongoose'

StreamSchema = new Mongo.Schema
  title:       { type: String, unique: yes ,index: yes }
  description: String
  background:  String
  feeds:       [{ type: Mongo.Schema.Types.ObjectId, ref: 'feeds' }]

# find-by-name
StreamSchema.statics.findByTitle = (title, callback) ->
  @findOne title: title, {}, {}, (err, stream) ->
    console.error err if err
    return callback err, stream


exports.Stream = Mongo.model 'streams', StreamSchema