###

  WebSocket CLUD Events
  AjaxっぽいEventsを全部Socket.ioで行うルーティング
  
###

module.exports = exports = (io,socket) ->

  # include events
  Events = app.get('events')
  HelperEvent  = Events.HelperEvent  app
  StreamEvent  = Events.StreamEvent  app
  FeedEvent    = Events.FeedEvent    app
  CommentEvent = Events.CommentEvent app

  # Helper Events
  socket.on "find feed",     HelperEvent.findFeed        socket, url

  # Stream Events
  socket.on "get feed_list", StreamEvent.getFeedList     socket
  socket.on "change stream", StreamEvent.changeProperty  socket, data

  # Feed Events
  socket.on "add feed",      FeedEvent.addFeed           socket, data
  socket.on "delete feed",   FeedEvent.deleteFeed        socket, data

  # Page Events
  socket.on "get page",      PageEvent.getContents       socket, data
  socket.on "add star",      PageEvent.addStar           socket, data
  socket.on "delete star",   PageEvent.deleteStar        socket, data

  # Comment Events
  socket.on "add comment",   CommentEvent.addComment     socket, data