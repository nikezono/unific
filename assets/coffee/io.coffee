window.ioApiWrapper = (socket)->

  subscribeFeed:(currentStream,targetFeed)->
    socket.emit "subscribeFeed",
      stream:currentStream
      feed:targetFeed

  subscribeStream:(currentStream,targetStream)->

  unsubscribeFeed:(currentStream,targetFeed)->
    socket.emit "unsubscribeFeed",
      stream:currentStream
      feed:targetFeed

