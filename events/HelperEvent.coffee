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
    return socket.emit "serverError","Error:unhandled"

  # find feed or stream
  findFeed:(socket,data) ->
    if data.query.match /^(http:\/\/|https:\/\/)/
      finder data.query, (err,candidates)=>
        if err
          debug err
          return @error err,socket
        return socket.emit 'foundFeed',
          candidates:candidates
          url: data.query

    # @todo ストリーム検索/フィード検索(キーワード検索)
    # @todo not found
    else
      Stream.findByTitle data.query,(err,stream)->
        if err
          debug err
          return @error err,socket
        return socket.emit 'foundStream',
          stream:stream
