# Batch Processing
# 3分おきにRSSフィードを全件探索

path = require 'path'

app = require path.resolve('config','app')
updater = app.get('helper').updateStream(app)
updater.update()
setInterval ->
  updater.update()
,1000*60*3