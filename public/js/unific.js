
/*

@todo エラーハンドラ
 */

(function() {
  var path, socket;

  path = window.location.pathname.substr(1);

  socket = io.connect();

  socket.emit('connect stream', path);

  window.navigationController = function($scope) {
    return $scope.addFeed = function() {
      return socket.emit('subscribeFeed', {
        stream: path,
        feed: "hoge"
      });
    };
  };

  window.pageController = function($scope) {};

}).call(this);
