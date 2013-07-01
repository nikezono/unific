###

  WebSocket CLUD Events
  AjaxっぽいEventsを全部Socket.ioで行うルーティング
  
###

module.exports = exports = (socket) ->

  # include events
  Events = app.get('events')
  HelperEvent  = Events.HelperEvent  app
  HomeEvent    = Events.HomeEvent    app
  StreamEvent  = Events.StreamEvent  app
  CommentEvent = Events.CommentEvent app

  # Helper Events
  socket.on "find feed",     HelperEvent.findFeed socket,url

  # Stream Events
  socket.on "get feed_list", StreamEvent.getFeedList socket
  socket.on "change stream", StreamEvent.changeProperty socket, data

  # Page Events
  socket.on "get page",      PageEvent.getContents socket, data
  socket.on "add star",      PageEvent.addStar socket, data
  socket.on "delete star",   PageEvent.deleteStar socket, data

  # Comment Events
  socket.on "add comment",   CommentEvent.addComment socket, data