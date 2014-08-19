(function() {
  window.unificApiWrapper = function() {
    return {
      findFeed: function(currentStream, queryWord, callback) {
        return $.getJSON("/api/find", {
          query: queryWord,
          stream: currentStream
        }).success(function(data) {
          return callback(null, data);
        }).error(function(err) {
          return callback(err, null);
        });
      },
      getFeedList: function(currentStream) {
        return $.getJSON("/" + currentStream + "/list").success(function(data) {
          return callback(null, data);
        }).error(function(err) {
          return callback(err, null);
        });
      }
    };
  };

}).call(this);
