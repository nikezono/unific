###

  routes.coffee
  httpリクエスト用ルーティング設定ファイル

###

module.exports = (app) ->

  # include events
  HomeEvent   = app.get('events').HomeEvent app
  StreamEvent = app.get('events').StreamEvent app

  # homeEvent Controller
  app.get '/',              HomeEvent.index
  app.get '/about',         HomeEvent.about

  # streamEvent Controller
  app.get '/:stream',       StreamEvent.index
  app.get '/:stream/rss',   StreamEvent.rss

  # 404 Not Found
  app.get '/:stream/*', (req,res,next)->
    res.send "404 Error"