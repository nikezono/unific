(function() {
  window.ioApiWrapper = function(socket) {
    return {
      subscribeFeed: function(currentStream, targetFeed) {
        return socket.emit("subscribeFeed", {
          stream: currentStream,
          feed: targetFeed
        });
      },
      subscribeStream: function(currentStream, targetStream) {},
      unsubscribeFeed: function(currentStream, targetFeed) {
        return socket.emit("unsubscribeFeed", {
          stream: currentStream,
          feed: targetFeed
        });
      }
    };
  };

}).call(this);
