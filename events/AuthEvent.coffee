###

  FeedEvent.coffee

###

module.exports.AuthEvent = (app,passport) ->

  User = app.get('models').User

  # @todo Error Messageの場合分け
  logIn: passport.authenticate "local",
    successRedirect: "/home"
    failureRedirect: "/"
    failureFlash   : "Invalid Username or Password."

  logOut: (req, res) ->
    req.logout()
    req.session.destroy()
    return res.redirect '/'

  # @todo emailのvalidation
  signUp: (req,res)->
    User.createWithValidate
      email: req.param('email')
      name : req.param('username')
      password: req.param('password')
    ,(err,user)-> 
      if err
        req.flash('error','Invalid Username or Email-address.')
        return res.redirect '/'
      else
        req.flash('info',"User #{user.name} is created.")
        return res.redirect '/'
    

