###

  routes.coffee
  httpリクエスト用ルーティング設定ファイル

###

module.exports = (app,passport) ->
  
  # include events
  HomeEvent   = app.get('events').HomeEvent app
  StreamEvent = app.get('events').StreamEvent app

  # Simple route middleware to ensure user is authenticated.
  ensureAuthenticated = (req, res, next) ->
    return next()  if req.isAuthenticated()
    res.redirect "/"

  # POST /login
  app.post "/log_in", passport.authenticate "local",
    successRedirect: "/my"
    failureRedirect: "/"


  app.get "/log_out", (req, res) ->
    req.logout()
    req.session.destroy()
    return res.send "log out"

  # User
  app.post '/sign_up', (req, res) -> HomeEvent.postSignUp req,res

  # homeEvent Controller
  app.get '/',              (req,res,next)-> HomeEvent.index   req,res,next
  app.get '/about',         (req,res,next)-> HomeEvent.about   req,res,next
  app.get '/my',            (req,res,next)-> HomeEvent.mypage  req,res,next

  # streamEvent Controller
  app.get '/:stream',       (req,res,next)-> StreamEvent.index req,res,next
  app.get '/:stream/rss',   (req,res,next)-> StreamEvent.rss   req,res,next

  # 404 Not Found
  app.get '/:stream/*',     (req,res,next)-> res.send "404 Error"