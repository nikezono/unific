window.httpApiWrapper = (currentStream)->

  # 購読できるフィード/ストリームの検索
  findCandidates:(queryWord,callback)->
    $.getJSON "/api/find",
      query:queryWord
      stream:currentStream
    .success (data)->
      callback null,data
    .error (err)->
      callback err,null

  # 現在のストリームの記事リスト
  getFeedList:(callback)->
    $.getJSON "/#{currentStream}/list"
    .success (data)->
      callback null,data
    .error (err)->
      callback err,null

  # 最新記事取得
  getLatestArticles:(callback)->
    $.getJSON "/#{currentStream}/latest"
    .success (data)->
      callback null,data
    .error (err)->
      callback err,data



