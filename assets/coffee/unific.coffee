###

 unific.coffee

###

$ ->

  ### Configration & Initialize ###
  _.templateSettings =
    interpolate: /\{\{(.+?)\}\}/g

  path = (window.location.pathname).substr(1)
  socket = io "/#{path}"

  httpApi = httpApiWrapper(path)
  ioApi   = ioApiWrapper(socket)

  socket.on "connect",->
    notify.info "Connected."

  socket.on "error",(err)->
    notify.danger err

  socket.on "serverError",(err)->
    console.error err
    console.trace()
    alert.danger("Error")

  # Model & View Initialize
  articles       = new Articles()
  candidates     = new Candidates()
  articlesView   = new ArticlesView
    collection:articles
  candidatesView = new CandidatesView
    model: null
    collection:candidates
  time = null
  collapseCount = 0

  # Helper Method
  refresh = (callback)->

    # 3分以内であればリフレッシュしない
    return unless time is null or (new Date()/1 - time/1) > 1000*60*3
    time = new Date()

    httpApi.getLatestArticles (err,data)->
      if err
        console.error err
        return notify.danger "Initialize Error.Please Reload."

      newArticles = []
      for article in data
        newArticles.push new Article(article)
      articles.reset newArticles
      notify.success "Refreshed"
      return callback() if callback

  refreshCollapse = ->
    $('.collapse').collapse('hide') # @note Viewに書きたい
    $($('#accordion').find('.panel')[collapseCount]).find('.collapse').collapse('hide')
    collapseCount = 0
    $($('#accordion').find('.panel')[collapseCount]).find('.collapse').collapse('show')

  ## Marionette ##
  Unific = new Backbone.Marionette.Application()
  Unific.addRegions
    modals: '#Modals'
    pages: '#Pages'

  Unific.addInitializer (options)->
    Unific.pages.show articlesView
    Unific.modals.show candidatesView # @note modalなので常にshowしておいてjsで制御する

  # 初回記事読み込み
  if not _.isEmpty path
    refresh ->
      # Start App
      Unific.start()
      refreshCollapse()

  # 繋ぎ直した時
  socket.on 'reconnect',->
    refresh ->
      refreshCollapse()

  ## Socket.io EventHandlers ##
  socket.on "subscribed", (data)->
    notify.success "#{data.title} Subscribed."
    refresh ->
      refreshCollapse()
  socket.on "unsubscribed", (data)->
    notify.success "#{data.title} Unsubscribed."
    refresh ->
      refreshCollapse()

  socket.on "newArticle", (data)->
    notify.info(data.page.title)
    articles.unshift new Article data

  ## Keyboard Event ##
  $(window).keyup (e)->

    ## event ##
    if _.contains [39,40,34,32,13,45],e.keyCode # right,down,space,enter
      $before = $($('#accordion').find('.panel')[collapseCount]).find('.collapse').collapse('hide')
      collapseCount+=1 if $('#accordion').find('.panel').length > collapseCount
      $after = $($('#accordion').find('.panel')[collapseCount]).find('.collapse').collapse('show')
      $("html, body").animate
        scrollTop: $before.offset().top - 40
      , 200

      return true

    else if _.contains [37,38,33,8,35],e.keyCode # left,up,backspace
      $before = $($('#accordion').find('.panel')[collapseCount]).find('.collapse').collapse('hide')
      collapseCount-=1 if collapseCount > 0
      $after = $($('#accordion').find('.panel')[collapseCount]).find('.collapse').collapse('show')
      $("html, body").animate
        scrollTop: $after.offset().top - 40
      , 200

      return true

  resetCandidates = (data)->
    newCandidates = []
    for candidate in data
      newCandidates.push new Candidate candidate
    candidates.reset newCandidates
    $('.modal').modal()

  ## Navigation Event @note backboneに落としこむ
  $('button#Find').click ->
    query = $('#FindQuery').val()
    httpApi.findCandidates query,(err,data)->
      return notify.danger err if err
      return notify.danger "candidate not found" if _.isEmpty data
      resetCandidates(data)

  $('button#List').click ->
    httpApi.getFeedList (err,data)->
      return notify.danger err if err
      return notify.danger "no feed has subscribed" if _.isEmpty data
      resetCandidates(data)

  $('button#Hot').click ->
    return notify.danger "未実装"

  $('button#Fork').click ->
    return notify.danger "未実装"
