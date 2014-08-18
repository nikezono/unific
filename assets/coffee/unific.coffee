###

@todo エラーハンドラ

###

path = (window.location.pathname).substr(1)

socket = io.connect()
socket.emit 'connect stream', path

socket.on "serverError",(err)->
  console.error err
  console.trace()
  alert.danger("Error")


### AngularApp ###

window.navigationController = ($scope)->

  # Find Button
  $scope.findFeed = (query)->
    return if _.isEmpty query
    $.getJSON "/api/find",
      query:query
      stream:path
    .success (data)->
      if _.isEmpty data
        return notify.info "Not Found."
      console.log data
      $scope.candidates = data
      $scope.$apply()
      $('#FindFeedModal').modal()

    .error (err)->
      console.error err
      notify.danger "Error"

    # SubScribe Button
    $scope.subscribeFeed = (feed)->
      socket.emit "subscribeFeed",
        stream:path
        feed:feed
      notify.info "Subscribe Request"

    socket.on "subscribedFeed", ->
      notify.success "New Feed has Subscribed."


window.pageController = ($scope)->

  # 初回記事取得
  $.getJSON "/#{path}/latest"
  .success (data)->
    $scope.articles = data
    $scope.$apply()
    $('.collapse').collapse()
  .error (err)->
    console.error err
    notify.danger("Connection Error.")

  socket.on "newArticle", (data)->
    console.log data
    $scope.articles.unshift data
    $(".collapse").collapse()
    $scope.$apply()
    notify.info(data.page.title)


