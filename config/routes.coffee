###

  routes.coffee
  ルーティング設定ファイル

###

module.exports = (app) ->

  # include events
  homeEvent   = app.get('events').homeEvent app
  streamEvent = app.get('events').streamEvent app

  # homeEvent Controller
  app.get '/',              homeEvent.index
  app.get '/about',         homeEvent.about

  # streamEvent Controller
  app.get '/:stream',       streamEvent.index
  app.get '/:stream/rss',   streamEvent.rss

  # 404 Not Found
  app.get '/:stream/*', (req,res,next)->
    res.send "404 Error"