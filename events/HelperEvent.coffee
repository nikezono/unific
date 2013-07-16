###

  HelperEvent.coffee
  外部ライブラリのラッパ群

###

module.exports.HelperEvent = (app) ->

  finder = require 'find-rss'
  _      = require 'underscore'
  async  = require 'async'
  fs     = require "fs"
  path   = require "path"

  Stream = app.get('models').Stream
  domain = app.get('domain')
  port   = app.get('port')

  #@todo updateしないとutf-8以外のencodingのwebsiteを読み込めない
  findFeed:(socket,url) ->
    if url.match /^(http:\/\/|https:\/\/)/
      finder url, (error,candidates)-> 
        socket.emit 'found feed',error,
          candidates:candidates
          url: url
    else
      Stream.findByTitle url,(err,stream)->
        return socket.emit 'found feed', 'not found stream' unless stream?
        feedurl = "http://#{domain[0]}:#{port}/#{url}"
        finder feedurl, (error,candidates)-> 
          socket.emit 'found feed',error,
            candidates:candidates
            url: url

  uploadBg:(socket,io,data)->
    streamname = decodeURIComponent data.stream
    
    writeFile = data.file
    writePath = path.resolve 'public','images',"background","#{data.name}"
    writeStream = fs.createWriteStream(writePath)
    bgpath = "/images/background/#{data.name}"

    # 書き込み完了時の処理
    writeStream.on("drain", ->
    ).on("error", (exception) ->
      console.log "exception:" + exception
    ).on("close", ->
      Stream.findOne title:streamname, (err,stream)->
        return socket.emit 'error' if err?
        stream.background = bgpath
        stream.save()
        io.sockets.to(data.stream).emit 'bg uploaded' , bgpath
    ).on "pipe", (src) ->

    writeStream.write writeFile, "binary" #バイナリでお願いする
    writeStream.end()

  clearBg:(socket,io,data) ->
    streamname = decodeURIComponent data.stream
    Stream.findOne title:streamname, (err,stream)->
      return socket.emit 'error' if err?
      stream.background = undefined
      stream.save()
      io.sockets.to(data.stream).emit 'bg cleared'