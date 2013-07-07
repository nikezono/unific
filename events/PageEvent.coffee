###

  PageEvent.coffee

###

module.exports.PageEvent = (app) ->

  ###
  # dependency
  ###
  ex = require 'extractcontent'

  ###
  # socket.io events
  ###

  getContents:(socket,data) ->
    ex.extractFromUrl data.url, (error, result) ->
      return socket.emit 'error' if error
      result.content = encodeURIComponent result.content.replace(/\n/g,'<br>')
      return socket.emit 'got page',
        res:result
        domid:data.domid

  addStar: (socket,data) ->
    console.log data

  deleteStar: (socket,data) ->
    console.log data