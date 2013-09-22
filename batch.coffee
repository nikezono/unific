# Batch Processing
# 3分おきにRSSフィードを全件探索

path = require 'path'
moment = require 'moment'

process.on 'uncaughtException', (err)->
  console.error err

app = require path.resolve('config','app')
updater = app.get('helper').updateStream(app)
console.log "batch processing worker standby: #{moment().format();}"
updater.update()
setInterval ->
  console.log "batch processing loop is called: #{moment().format();}"
  updater.update()
,1000*60*3
