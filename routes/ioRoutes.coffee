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
  socket.on "get feed_list", (data) -> StreamEvent.getFeedList     socket, data
  socket.on "sync stream",   (data) -> StreamEvent.sync            socket, data
  socket.on "change stream", (data) -> StreamEvent.changeProperty  socket, io, data

  # Feed Events
  socket.on "add feed",      (data) -> FeedEvent.addFeed           socket, io,data
  socket.on "edit feed_list",(data) -> FeedEvent.editFeedList      socket, io,data

  # Page Events
  socket.on "add star",      (data) -> PageEvent.addStar           socket, io,data
  socket.on "delete star",   (data) -> PageEvent.deleteStar        socket, io,data
  socket.on "add comment",   (data) -> PageEvent.addComment        socket, io, data


