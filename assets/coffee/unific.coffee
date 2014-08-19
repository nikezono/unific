###

 unific.coffee

###


path = (window.location.pathname).substr(1)

socket = io.connect "/#{path}"
socket.emit 'connect stream', path

socket.on "serverError",(err)->
  console.error err
  console.trace()
  alert.danger("Error")

httpApi = httpApiWrapper(path)
ioApi   = ioApiWrapper(socket)

## Marionette ##
Unific = new Backbone.Marionette.Application()
Unific.addRegions
  pages:'#Pages'

## Model ##
Article  = Backbone.Model.extend()
Articles = Backbone.Collection.extend Article


## ItemView ##
ArticleView = Backbone.Marionette.ItemView.extend
  template:"#articleTemplate"

## CollectionView ##
ArticlesView = Backbone.Marionette.CollectionView.extend
  childView:ArticleView
  tagName:'div'
  className:'panel-group'
  id:'accordion'

Unific.addInitializer (options)->
  Unific.pages.show new ArticlesView
    collection:options.articles


$ ->

  articles = new Articles()

  # 初回記事読み込み
  httpApi.getLatestArticles (err,data)->
    if err
      console.error err
      return notify.danger "Initialize Error.Please Reload."
    for article in data
      articles.add new Article(article)

    Unific.start
      articles:articles

  socket.on "subscribedFeed", ->
    notify.success "New Feed has Subscribed."
  socket.on "unsubscribedFeed", ->
    notify.success "New Feed has Subscribed."

  socket.on "newArticle", (data)->
    console.log data
    notify.info(data.page.title)
    articles.add data

