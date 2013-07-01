###

  CommentEvent.coffee

###

module.exports.CommentEvent = (app) ->

  ###
  # socket.io events
  ###

  addComment:(data)->
    console.log data.comment