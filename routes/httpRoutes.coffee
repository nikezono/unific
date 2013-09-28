###

  routes.coffee
  httpリクエスト用ルーティング設定ファイル

###

module.exports = (app,passport) ->
  
  # include events
  HomeEvent   = app.get('events').HomeEvent app
  AuthEvent   = app.get('events').AuthEvent app,passport
  StreamEvent = app.get('events').StreamEvent app

  # Simple route middleware to ensure user is authenticated.
  ensureAuthenticated = (req, res, next) ->
    return next()  if req.isAuthenticated()
    res.redirect "/"

  # Auth Event Controller
  app.post "/log_in",       AuthEvent.logIn
  app.get "/log_out",       (req,res,next)-> AuthEvent.logOut req,res,next
  app.post '/sign_up',      (req,res,next)-> AuthEvent.signUp req,res,next

  # homeEvent Controller
  app.get '/',              (req,res,next)-> HomeEvent.index   req,res,next
  app.get '/about',         (req,res,next)-> HomeEvent.about   req,res,next
  app.get '/team',          (req,res,next)-> HomeEvent.team    req,res,next
  app.get '/home',          (req,res,next)-> HomeEvent.mypage  req,res,next

  # streamEvent Controller
  app.get '/:stream',       (req,res,next)-> StreamEvent.index req,res,next
  app.get '/:stream/rss',   (req,res,next)-> StreamEvent.rss   req,res,next

  # 404 Not Found
  app.get '/:stream/*',     (req,res,next)-> res.send "404 Error"