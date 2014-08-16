
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
    return console.trace();
  });

  window.navigationController = function($scope) {
    return $scope.findFeed = function(query) {
      if (_.isEmpty(query)) {
        return;
      }
      $.getJSON("/api/find", {
        query: query
      }).success(function(data) {
        $scope.candidates = data;
        $scope.$apply();
        return $('#FindFeedModal').modal();
      }).error(function(err) {
        return console.error(err);
      });
      $scope.subscribeFeed = function(feed) {
        return socket.emit("subscribeFeed", {
          stream: path,
          feed: feed
        });
      };
      return socket.on("subscribedFeed", function() {
        return console.log("subscribed");
      });
    };
  };

  window.pageController = function($scope) {
    $.getJSON("/" + path + "/latest").success(function(data) {
      console.log(data);
      $scope.pages = data;
      return $scope.$apply();
    }).error(function(err) {
      return console.error(err);
    });
    return socket.on("newArticle", function(data) {
      return $scope.pages = $scope.pages.unshift(data.page);
    });
  };

}).call(this);
