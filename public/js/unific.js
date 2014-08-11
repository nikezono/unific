
/*

@todo エラーハンドラ
 */

(function() {
  var path, socket;

  path = window.location.pathname.substr(1);

  socket = io.connect();

  socket.emit('connect stream', path);

  socket.on("error", function(err) {
    return console.log(err);
  });

  window.modalController = function($scope) {
    socket.on("foundFeed", function(data) {
      if ((data.candidates != null) && data.candidates.length() > 0) {
        console.log(data);
        $scope.feeds = data.candidates;
        $scope.apply();
        return $('#FindFeedModal').modal();
      }
    });
    return socket.on("foundStream", function(data) {
      return console.log(data);
    });
  };

  window.navigationController = function($scope) {
    return $scope.findFeed = function() {
      return socket.emit('findFeed', {
        stream: path,
        query: $scope.findFeedQuery
      });
    };
  };

  window.pageController = function($scope) {};

}).call(this);
