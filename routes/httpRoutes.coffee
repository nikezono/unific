###

  routes.coffee
  httpリクエスト用ルーティング設定ファイル

###

module.exports = (app) ->

  # include events
  HomeEvent   = app.get('events').HomeEvent app
  StreamEvent = app.get('events').StreamEvent app
  FeedEvent   = app.get('events').FeedEvent app
  PageEvent   = app.get('events').PageEvent app
  HelperEvent = app.get('events').HelperEvent app

  # homeEvent Controller
  app.get '/',               (req,res,next)-> HomeEvent.index   req,res,next
  app.get '/about',          (req,res,next)-> HomeEvent.about   req,res,next
  app.get  /^\/%3c%/i,       (req,res,next)-> res.send 404 # underscore template
  app.get  /^\/%7b%/i,       (req,res,next)-> res.send 404 # underscore template

  # HelperEvent Controller
  app.get '/api/find',       (req,res,next)-> HelperEvent.findFeed req,res,next

  # streamEvent Controller
  app.get '/:stream',        (req,res,next)-> StreamEvent.index req,res,next
  app.get '/:stream/rss',    (req,res,next)-> StreamEvent.rss   req,res,next

  # FeedEvent Controller
  app.get '/:stream/list',   (req,res,next)-> FeedEvent.list    req,res,next

  # PageEvent Controller
  app.get '/:stream/latest', (req,res,next)-> PageEvent.getPagesByStream req,res,next

  # 404 Not Found
  app.get '/:stream/*',      (req,res,next)-> res.send 404
