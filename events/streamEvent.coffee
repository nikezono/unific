###

  StreamEvent.coffee

###

module.exports.StreamEvent = (app) ->

  ###
  # http request
  ###

  index: (req,res,next)->
    stream = req.params.stream
    res.render 'stream',
      title: "#{stream}"
      description: 'Site Description'

  rss  : (req,res,next)->
    res.send "return combined rss"

  ###
  # socket.io events
  ###
  getFeedList: (socket) ->
    console.log socket

  sync : (socket) ->
    console.log socket

  changeProperty: (socket,io,data) ->
    console.log socket
