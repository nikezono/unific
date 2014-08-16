###

@todo エラーハンドラ

###

path = (window.location.pathname).substr(1)

socket = io.connect()
socket.emit 'connect stream', path

socket.on "serverError",(err)->
  console.error err
  console.trace()

window.navigationController = ($scope)->

  # Find Button
  $scope.findFeed = (query)->
    return if _.isEmpty query
    $.getJSON "/api/find",
      query:query
    .success (data)->
      $scope.candidates = data
      $scope.$apply()
      $('#FindFeedModal').modal()
    .error (err)->
      console.error err

    # SubScribe Button
    $scope.subscribeFeed = (feed)->
      socket.emit "subscribeFeed",
        stream:path
        feed:feed
    socket.on "subscribedFeed", ->
      console.log "subscribed" #@todo notice


window.pageController = ($scope)->

  $.getJSON "/#{path}/latest"
  .success (data)->
    $scope.articles = data
    $scope.$apply()
  .error (err)->
    console.error err

  socket.on "newArticle", (data)->
    console.log data
    $scope.articles.unshift data
    $scope.$apply()


