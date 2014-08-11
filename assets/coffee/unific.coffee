###

@todo エラーハンドラ

###

path = (window.location.pathname).substr(1)

socket = io.connect()
socket.emit 'connect stream', path

window.navigationController = ($scope)->
  $scope.addFeed = ->
    socket.emit 'subscribeFeed',
      stream:path
      feed:"hoge"

window.pageController = ($scope)->


