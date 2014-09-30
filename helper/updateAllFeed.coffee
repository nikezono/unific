###
#
# updateAllFeed.coffee
# フィード全件のタイトルやfaviconなどを取得しなおす
# バッチ処理？
#
###

debug  = require('debug')('unific:updateAllFeed')
async  = require 'async'
finder = require 'find-rss'
path   = require 'path'


app = require path.resolve('config','app')
Feed = app.get('models').Feed

Feed.find {}, (err,feeds)->
  return debug err if err

  async.each feeds,(feed,cb)->
    debug "UPDATE"
    debug feed.title
    debug feed.url
    debug feed.favicon
    debug "MODIFIED TO"

    finder feed.url,(err,candidates)->
      debug "hoge"
      debug candidates
      debug err if err
      return cb() if err
      candidate = candidates[0] # フィード自体を指定しているので
      feed.title = candidate.title
      feed.favicon = candidate.favicon
      feed.save (err,result)->
        debug err if err
        debug result.title
        debug result.favicon
        return cb()
  ,->
    debug "All Feed Is Update"
    process.exit()



