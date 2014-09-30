###

  server.coffee
  起動スクリプト

###

newrelicEnable = (
  process.env.NEW_RELIC_APP_NAME? and
  process.env.NEW_RELIC_LICENSE_KEY? and
  process.env.NEW_RELIC_NO_CONFIG_FILE?
)
console.log "using newrelic:#{newrelicEnable}"
if newrelicEnable
  require 'newrelic'

# dependency
http = require "http"
path = require 'path'

# user library
app = require path.resolve('config','app')
io  = require path.resolve('config','io')

# start socket.io and http server
server = http.createServer app
io app,server

# start rss crowler
crowler = require(path.resolve 'config','crowler') app
crowler.initialize()
app.set 'crowler',crowler

# start batch processing
require path.resolve('helper','updateAllFeed')
setInterval ->
  require path.resolve('helper','updateAllFeed')
,1000*60*60 # 1時間おきにフィードリスト更新

server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")


