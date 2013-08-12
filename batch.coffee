# Batch Processing
# 3分おきにRSSフィードを全件探索

path = require 'path'

app = require path.resolve('config','app')
updater = app.get('helper').updateStream(app)
console.log "batch processing worker standby: #{Date.now}"
updater.update()
setInterval ->
  console.log "batch processing loop is called: #{Date.now}"
  updater.update()
,1000*60*3
