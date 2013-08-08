
###

  auth.coffee
  Passportの認証ロジック

###

module.exports = (app,passport) ->

  User = app.get('models').User

  LocalStrategy = require('passport-local').Strategy

  # Passport session setup.
  passport.serializeUser (user, done) ->
    createAccessToken = ->
      token = user.generateRandomToken()
      User.findOne
        accessToken: token
      , (err, existingUser) ->
        return done(err)  if err
        if existingUser
          createAccessToken() # Run the function again - the token has to be unique!
        else
          user.set "accessToken", token
          user.save (err) ->
            return done(err)  if err
            done null, user.get("accessToken")

    createAccessToken()  if user._id

  passport.deserializeUser (token, done) ->
    User.findOne
      accessToken: token
    , (err, user) ->
      done err, user

  # Use the LocalStrategy within Passport.
  passport.use new LocalStrategy((username, password, done) ->
    User.findOne
      name: username
    , (err, user) ->
      return done(err)  if err
      unless user
        return done(null, false,
          message: "Unknown user " + username
        )
      user.comparePassword password, (err, isMatch) ->
        return done(err)  if err
        if isMatch
          done null, user
        else
          done null, false,
            message: "Invalid password"
  )