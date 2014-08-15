###

@todo エラーハンドラ

###

path = (window.location.pathname).substr(1)

socket = io.connect()
socket.emit 'connect stream', path

socket.on "serverError",(err)->
  console.error err
  console.trace()

  $scope.subscribeFeed = (feed)->
    socket.emit "subscribeFeed",
      stream:path
      feed:feed

window.navigationController = ($scope)->
  $scope.findFeed = (query)->
    return if _.isEmpty query
    $.getJSON "/api/find",
      query:query
    ,->
      console.log "request end"
    .success (data)->
      $scope.feeds = data
      $scope.$apply()
      $('#FindFeedModal').modal()
    .error (err)->
      console.error err



window.pageController = ($scope)->

  socket.on "newArticle", (data)->
    console.log data


