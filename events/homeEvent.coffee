###

  HomeEvent.coffee

###

module.exports.HomeEvent = (app) ->

  User = app.get('models').User

  index: (req,res)->
    if req.user
      return res.redirect 'my'
    return res.render "index",
      title :  'unific'

  # @todo 実装 とりあえずuserのhashを返してる
  about: (req,res)->
    res.send req.user

  mypage: (req,res)->
    res.render "my",
      title: req.user.name
      user:req.user

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
    