###

  UserSchema.coffee

  * email       [String] Identifier
  * name        [String]
  * icon        [String]
  * password    [String]
  * accessToken
  * stargazes   [Array] Starを付けたPageのObjectId Array
  * subscribes  [Array] SubscribeしているStreamのObjectId Array
  * streams     [Array] CreateしたStreamのObjectId Array

###

Mongo  = require 'mongoose'
bcrypt = require 'bcrypt'
async  = require 'async'
SALT_WORK_FACTOR = 10;

UserSchema = new Mongo.Schema
  email:           { type: String, required: true,unique:true, index: yes }
  name:            { type: String, required: true,unique:true }
  password:        { type: String, required: true,unique:true }
  icon_url:        { type: String, default: '' }
  accessToken:     { type: String }
  stargazes:      [{ type: Mongo.Schema.Types.ObjectId, ref: 'pages' }]
  subscribes:     [{ type: Mongo.Schema.Types.ObjectId, ref: 'streams' }]
  streams:        [{ type: Mongo.Schema.Types.ObjectId, ref: 'streams' }]

UserSchema.statics.getStreamsById = (id,callback)->
  @findOne {_id:id},{},{ populate: 'streams' },(err,user)->
    return callback err,null if err
    return callback null,user.streams

UserSchema.statics.getSubscribesById = (id,callback)->
  @findOne {_id:id},{},{ populate: 'streams' },(err,user)->
    return callback err,null if err
    return callback null,user.subscribes

UserSchema.statics.getStarGazesById = (id,callback)->
  @findOne {_id:id},{},{ populate: 'streams' },(err,user)->
    return callback err,null if err
    return callback null,user.stargazes

# Bcrypt middleware
UserSchema.pre "save", (next) ->
  user = this
  return next()  unless user.isModified("password")
  bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
    return next(err)  if err
    bcrypt.hash user.password, salt, (err, hash) ->
      return next(err)  if err
      user.password = hash
      next()
      
# Password verification
UserSchema.methods.comparePassword = (candidatePassword, cb) ->
  bcrypt.compare candidatePassword, @password, (err, isMatch) ->
    return cb(err)  if err
    cb null, isMatch

# Remember Me implementation helper method
UserSchema.methods.generateRandomToken = ->
  user = this
  chars = "_!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
  token = new Date().getTime() + "_"
  x = 0

  while x < 16
    i = Math.floor(Math.random() * 62)
    token += chars.charAt(i)
    x++
  token

# @todo バリデーション
UserSchema.statics.createWithValidate = (data,callback)->
  that = @

  # Fully Path is required
  return callback '全ての欄を埋めてください',null unless (data.name and data.email and data.password)

  # @todo crypt
  # @todo メールバリデータ

  # 一意性
  uniqueQuery = that.find()
  uniqueQuery.or
    name:data.name
    email:data.email
  .exec (err,users)->
    return callback err, nulll if err
    return callback 'すでにemailかnameが使われています',null if users.length > 0

    that.create
      name: data.name
      email: data.email
      password:data.password
    ,(err,user)-> 
      return callback err,null if err
      callback null,user

exports.User = Mongo.model 'users', UserSchema