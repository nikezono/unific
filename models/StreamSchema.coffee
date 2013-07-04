###

  streamSchema.coffee

  * title [String] タイトル
  * description [String] ページ上部の説明
  * feeds [ObjectId] ObjectIdのArray
  * password [String] BasicAuthのパスワード

###

Mongo = require 'mongoose'
combiner = require('combine-rss').combiner()

StreamSchema = new Mongo.Schema
  title:       { type: String, unique: yes ,index: yes }
  description: String
  combiner:    {}
  feeds:       [{ type: Mongo.Schema.Types.ObjectId, ref: 'feeds' }]


# Post-init
StreamSchema.post 'init', (stream)->
  stream.combiner = combiner
  stream.markModified 'combiner'
  stream.save()

# find-by-name
StreamSchema.statics.findByTitle = (title, callback) ->
  @findOne title: title, {}, {}, (err, stream) ->
    console.error err if err
    return callback err, stream


exports.Stream = Mongo.model 'streams', StreamSchema