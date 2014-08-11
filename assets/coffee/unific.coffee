###

@todo エラーハンドラ

###

path = (window.location.pathname).substr(1)

socket = io.connect()
socket.emit 'connect stream', path

socket.on "error",(err)->
  console.log err

window.modalController = ($scope)->
  socket.on "foundFeed",(data)->

    if data.candidates? and data.candidates.length() > 0
      console.log data
      $scope.feeds = data.candidates
      $scope.apply()
      $('#FindFeedModal').modal()

  socket.on "foundStream",(data)->
    console.log data

window.navigationController = ($scope)->
  $scope.findFeed = ->
    socket.emit 'findFeed',
      stream:path
      query:$scope.findFeedQuery

window.pageController = ($scope)->


