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
  socket.on "findFeed",      (url)  -> HelperEvent.findFeed        socket, url

  # Stream Events
  socket.on "getFeedList",   (data) -> StreamEvent.getFeedList     socket, data
  socket.on "subscribeFeed", (data) -> StreamEvent.subscribeFeed   socket, data
  socket.on "changeDesc",    (data) -> StreamEvent.changeDesc      socket, io, data

  # Feed Events
  socket.on "createFeed",    (data) -> FeedEvent.createFeed        data,socket

  # Page Events
  socket.on "addStar",       (data) -> PageEvent.addStar           socket, io,data
  socket.on "addComment",    (data) -> PageEvent.addComment        socket, io, data


