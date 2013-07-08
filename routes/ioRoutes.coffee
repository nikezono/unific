###

  WebSocket CLUD Events
  AjaxっぽいEventsを全部Socket.ioで行うルーティング
  
###

module.exports = exports = (app,io,socket) ->

  # include events
  Events       = app.get('events')
  HelperEvent  = Events.HelperEvent  app
  StreamEvent  = Events.StreamEvent  app
  FeedEvent    = Events.FeedEvent    app
  PageEvent    = Events.PageEvent    app

  # Helper Events
  socket.on "find feed",     (url)  -> HelperEvent.findFeed        socket, url

  # Stream Events
  socket.on "get feed_list",        -> StreamEvent.getFeedList     socket
  socket.on "sync stream",   (data) -> StreamEvent.sync            socket, io, data
  socket.on "change stream", (data) -> StreamEvent.changeProperty  socket, io, data

  # Feed Events
  socket.on "add feed",      (data) -> FeedEvent.addFeed           socket, data
  socket.on "delete feed",   (data) -> FeedEvent.deleteFeed        socket, data
  socket.on "active feed",   (data) -> FeedEvent.activeFeed        socket, data
  socket.on "inactive feed", (data) -> FeedEvent.inactiveFeed      socket, data

  # Page Events
  socket.on "get page",      (data) -> PageEvent.getContents       socket, data
  socket.on "add star",      (data) -> PageEvent.addStar           socket, data
  socket.on "delete star",   (data) -> PageEvent.deleteStar        socket, data
  socket.on "add comment",   (data) -> PageEvent.addComment        socket, io, data


