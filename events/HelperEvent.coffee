###

  HelperEvent.coffee
  外部ライブラリのラッパ群

###

module.exports.HelperEvent = (app) ->

  finder = require 'find-rss'

  #@todo 例外処理系の統一
  findFeed:(socket,url) ->
    finder url, (error,candidates)-> 
      socket.emit 'found feed',error,
        candidates:candidates
        url: url