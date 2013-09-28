###

  HomeEvent.coffee

###

module.exports.HomeEvent = (app) ->

  util = require 'util'

  User = app.get('models').User

  index: (req,res)->
    if req.user
      return res.redirect '/home'
    return res.render "index",
      title :  'Unific'

  # @todo 実装 とりあえずuserのhashを返してる
  about: (req,res)->
    res.send "about" + req.user

  team: (req,res)->
    res.send "team" + req.user

  # @note populateでStargazesとSubscribesとCreates全部引っ張ってきてるので、
  # スケーラビリティに欠けるかもしれない。(socket.ioでpartialにpullしたほうがいいかも)
  mypage: (req,res)->
    if req.user
      User.findOne({accessToken:req.user.accessToken})
      .populate('stargazes')
      .populate('subscribes')
      .populate('streams')
      .exec (err,user)->
        console.log user
        return res.send "502 Error, #{err}" if err
        res.render "home",
          title: user.name + " - Unific"
          user: user
    else
      res.redirect "/"

  postSignUp: (req,res)->
    User.createWithValidate
      email: req.param('email')
      name : req.param('username')
      password: req.param('password')
    ,(err,user)-> 
      if err
        return res.send "error : #{err}" 
      else
        res.send "user #{user._id} is created"
    