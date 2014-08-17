
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
    return alert.danger("Error");
  });


  /* AngularApp */

  window.navigationController = function($scope) {
    return $scope.findFeed = function(query) {
      if (_.isEmpty(query)) {
        return;
      }
      $.getJSON("/api/find", {
        query: query,
        stream: path
      }).success(function(data) {
        if (_.isEmpty(data)) {
          return notify.info("Not Found.");
        }
        console.log(data);
        $scope.candidates = data;
        $scope.$apply();
        return $('#FindFeedModal').modal();
      }).error(function(err) {
        console.error(err);
        return notify.danger("Error");
      });
      $scope.subscribeFeed = function(feed) {
        socket.emit("subscribeFeed", {
          stream: path,
          feed: feed
        });
        return notify.info("Subscribe Request");
      };
      return socket.on("subscribedFeed", function() {
        return notify.success("New Feed has Subscribed.");
      });
    };
  };

  window.pageController = function($scope) {
    $.getJSON("/" + path + "/latest").success(function(data) {
      $scope.articles = data;
      $scope.$apply();
      return $('.collapse').collapse();
    }).error(function(err) {
      console.error(err);
      return notify.danger("Connection Error.");
    });
    return socket.on("newArticle", function(data) {
      console.log(data);
      $scope.articles.unshift(data);
      $("#" + data.page._id).collapse();
      $scope.$apply();
      return notify.info(data.page.title);
    });
  };

}).call(this);
