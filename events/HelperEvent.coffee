###

  HelperEvent.coffee
  なんか切り分けできてないやつ

###

module.exports.HelperEvent = (app) ->

  finder = require 'find-rss'
  debug = require('debug')('events/helper')

  Stream = app.get('models').Stream

  # 汎用socket.ioエラー
  error: (err,socket)->
    # @todo エラー種別判定してメッセージ変える
    return socket.emit error,"Error:unhandled"

  # find feed or stream
  findFeed:(socket,url) ->
    if url.match /^(http:\/\/|https:\/\/)/
      finder url, (error,candidates)->
        if error
          debug error
          return @error err,socket
        return socket.emit 'foundFeed',
          candidates:candidates
          url: url

    else
      Stream.findByTitle url,(err,stream)->
        if error
          debug error
          return @error err,socket
        return socket.emit 'foundStream',
          stream:stream
