(function() {
  window.httpApiWrapper = function(currentStream) {
    return {
      findCandidates: function(queryWord, callback) {
        return $.getJSON("/api/find", {
          query: queryWord,
          stream: currentStream
        }).success(function(data) {
          return callback(null, data);
        }).error(function(err) {
          return callback(err, null);
        });
      },
      getFeedList: function(callback) {
        return $.getJSON("/" + currentStream + "/list").success(function(data) {
          return callback(null, data);
        }).error(function(err) {
          return callback(err, null);
        });
      },
      getLatestArticles: function(callback) {
        return $.getJSON("/" + currentStream + "/latest").success(function(data) {
          return callback(null, data);
        }).error(function(err) {
          return callback(err, data);
        });
      },
      sendSubscribeEvent: function(data, callback) {
        var action;
        action = data.action;
        return $.getJSON("/" + currentStream + "/" + action, {
          model: data.model
        }).success(function(data) {
          return callback(null, data);
        }).error(function(err) {
          return callback(err, null);
        });
      }
    };
  };

}).call(this);
