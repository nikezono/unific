
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

  window.modalController = function($scope) {
    socket.on("foundFeed", function(data) {
      if (data.candidates != null) {
        $scope.feeds = data.candidates;
        $scope.$apply();
        return $('#FindFeedModal').modal();
      }
    });
    socket.on("foundStream", function(data) {
      return console.log(data);
    });
    return $scope.subscribeFeed = function(feedUrl) {
      return console.log("sub " + feedUrl);
    };
  };

  window.navigationController = function($scope) {
    return $scope.findFeed = function() {
      if (_.isEmpty($scope.findFeedQuery)) {
        return;
      }
      return socket.emit('findFeed', {
        stream: path,
        query: $scope.findFeedQuery
      });
    };
  };

  window.pageController = function($scope) {};

}).call(this);
