###

  UserSchema.coffee

  * email       [String] Identifier
  * name        [String]
  * icon        [String]
  * password    [String]
  * accessToken
  * stargazes
  * subscribes
  * streams

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

UserSchema.statics.createWithValidate = (data,callback)->
  that = @

  # Fully Path is required
  return callback 'fully pass is required',null unless (data.name and data.email and data.password)

  # @todo crypt

  that.create
    name: data.name
    email: data.email
    password:data.password
  ,(err,user)-> 
    return callback err,null if err
    callback null,user

exports.User = Mongo.model 'users', UserSchema