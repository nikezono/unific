###

  commentSchema.coffee

  * comment      [String]     コメント本文
  * page         [ObjectId]   親page


###

Mongo = require 'mongoose'

CommentSchema = new Mongo.Schema
  comment:     String
  feed:        { type: Mongo.Schema.Types.ObjectId, ref: 'pages' }

exports.Comment = Mongo.model 'comment', CommentSchema