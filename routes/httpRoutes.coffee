###

  routes.coffee
  httpリクエスト用ルーティング設定ファイル

###

module.exports = (app) ->

  # include events
  HomeEvent   = app.get('events').HomeEvent app
  StreamEvent = app.get('events').StreamEvent app

  # homeEvent Controller
  app.get '/',              (req,res,next)-> HomeEvent.index   req,res,next
  app.get '/about',         (req,res,next)-> HomeEvent.about   req,res,next

  # streamEvent Controller
  app.get '/:stream',       (req,res,next)-> StreamEvent.index req,res,next
  app.get '/:stream/rss',   (req,res,next)-> StreamEvent.rss   req,res,next

  # 404 Not Found
  app.get '/:stream/*',     (req,res,next)-> res.send 404
