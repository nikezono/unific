###

  HelperEvent.coffee
  外部ライブラリのラッパ群

###

module.exports.HelperEvent = (app) ->

  finder = require 'find-rss'
  _      = require 'underscore'
  async  = require 'async'

  findFeed:(socket,url) ->
    finder url, (error,candidates)-> 
      socket.emit 'found feed',error,candidates
