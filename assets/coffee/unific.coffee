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

  ## Marionette ##
  Unific = new Backbone.Marionette.Application()
  Unific.addRegions
    modals: '#Modals'
    pages: '#Pages'

  Unific.addInitializer (options)->
    Unific.pages.show articlesView
    Unific.modals.show candidatesView # @note modalなので常にshowしておいてjsで制御する
    $('.collapse').collapse() # @note Viewに書きたい

  # 初回記事読み込み
  if not _.isEmpty path
    httpApi.getLatestArticles (err,data)->
      if err
        console.error err
        return notify.danger "Initialize Error.Please Reload."
      for article in data
        articles.add new Article(article)

      # Start App
      Unific.start()

  ## Socket.io EventHandlers ##
  socket.on "subscribedFeed", ->
    notify.success "New Feed has Subscribed."
  socket.on "unsubscribedFeed", ->
    notify.success "New Feed has Subscribed."

  socket.on "newArticle", (data)->
    notify.info(data.page.title)
    articles.unshift new Article data

  ## Navigation Event @note backboneに落としこむ
  $('button#Find').click ->
    query = $('#FindQuery').val()
    httpApi.findCandidates query,(err,data)->
      return notify.danger err if err
      return notify.danger "candidate not found" if _.isEmpty data

      newCandidates = []
      for candidate in data
        newCandidates.push new Candidate candidate
      candidates.reset newCandidates
      $('.modal').modal()
