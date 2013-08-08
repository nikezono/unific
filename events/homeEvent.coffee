###

  HomeEvent.coffee

###

module.exports.HomeEvent = (app) ->

  User = app.get('models').User

  index: (req,res)->
    res.render "index",
      title :  'unific',
      user  :  req.user

  about: (req,res)->
    res.send req.user

  postSignUp: (req,res)->
    User.createWithValidate
      email: req.param('email')
      name : req.param('username')
      password: req.param('password')
    ,(err,user)-> 
      if err
        return res.send 'error',"error : #{err}" 
      else
        res.send "user #{user._id} is created"
    