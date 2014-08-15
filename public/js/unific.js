
/*

@todo エラーハンドラ
 */

(function() {
  var path, socket;

  path = window.location.pathname.substr(1);

  socket = io.connect();

  socket.emit('connect stream', path);

  socket.on("serverError", function(err) {
    console.error(err);
    console.trace();
    return $scope.subscribeFeed = function(feed) {
      return socket.emit("subscribeFeed", {
        stream: path,
        feed: feed
      });
    };
  });

  window.navigationController = function($scope) {
    return $scope.findFeed = function(query) {
      if (_.isEmpty(query)) {
        return;
      }
      return $.getJSON("/api/find", {
        query: query
      }, function() {
        return console.log("request end");
      }).success(function(data) {
        $scope.feeds = data;
        $scope.$apply();
        return $('#FindFeedModal').modal();
      }).error(function(err) {
        return console.error(err);
      });
    };
  };

  window.pageController = function($scope) {
    return socket.on("newArticle", function(data) {
      return console.log(data);
    });
  };

}).call(this);
