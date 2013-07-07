###

  HelperEvent.coffee
  外部ライブラリのラッパ群

###

module.exports.HelperEvent = (app) ->

  finder = require 'find-rss'
  _      = require 'underscore'
  async  = require 'async'

  #@todo updateしないとutf-8以外のencodingのwebsiteを読み込めない
  findFeed:(socket,url) ->
    finder url, (error,candidates)-> 
      socket.emit 'found feed',error,
        candidates:candidates
        url: url
