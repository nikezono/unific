###

  FeedEvent.coffee

###

module.exports.FeedEvent = (app) ->

  Stream = app.get("models").Stream
  Feed   = app.get("models").Feed

  ###
  # socket.io events
  ###

  addFeed:(socket,data) -> 
    Stream.findByTitle data.stream, (err,stream)->
      console.log stream
    console.log data

  deleteFeed:(socket,data) ->
    console.log data

  activeFeed:(socket,data) ->
    console.log data

  inactiveFeed:(socket,data) ->
    console.log data