###

@todo エラーハンドラ

###

path = (window.location.pathname).substr(1)

socket = io.connect()
socket.emit 'connect stream', path

socket.on "serverError",(err)->
  console.error err
  console.trace()

window.modalController = ($scope)->

  socket.on "foundFeed",(data)->
    if data.candidates?
      $scope.feeds = data.candidates
      $scope.$apply()
      $('#FindFeedModal').modal()

  socket.on "foundStream",(data)->
    console.log data

  $scope.subscribeFeed = (feedUrl)->
    console.log "sub #{feedUrl}"

window.navigationController = ($scope)->
  $scope.findFeed = ->
    return if _.isEmpty $scope.findFeedQuery
    socket.emit 'findFeed',
      stream:path
      query:$scope.findFeedQuery

window.pageController = ($scope)->


