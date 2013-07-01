###

  WebSocket CLUD Events
  AjaxっぽいEventsを全部Socket.ioで行うルーティング
  
###

module.exports = exports = (socket) ->

  # include events
  HomeEvent   = app.get('events').HomeEvent app
  StreamEvent = app.get('events').StreamEvent app


  # Stream Events
  socket.on "get feed_list", StreamEvent.getFeedList socket

  # Page Events
  socket.on "get page",      PageEvent.getContents socket
  socket.on "add star",      PageEvent.addStar socket