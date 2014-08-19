
/*

 unific.coffee
 */

(function() {
  var Article, ArticleView, Articles, ArticlesView, Unific, httpApi, ioApi, path, socket;

  path = window.location.pathname.substr(1);

  socket = io.connect("/" + path);

  socket.emit('connect stream', path);

  socket.on("serverError", function(err) {
    console.error(err);
    console.trace();
    return alert.danger("Error");
  });

  httpApi = httpApiWrapper(path);

  ioApi = ioApiWrapper(socket);

  Unific = new Backbone.Marionette.Application();

  Unific.addRegions({
    pages: '#Pages'
  });

  Article = Backbone.Model.extend();

  Articles = Backbone.Collection.extend(Article);

  ArticleView = Backbone.Marionette.ItemView.extend({
    template: "#articleTemplate"
  });

  ArticlesView = Backbone.Marionette.CollectionView.extend({
    childView: ArticleView,
    tagName: 'div',
    className: 'panel-group',
    id: 'accordion'
  });

  Unific.addInitializer(function(options) {
    return Unific.pages.show(new ArticlesView({
      collection: options.articles
    }));
  });

  $(function() {
    var articles;
    articles = new Articles();
    httpApi.getLatestArticles(function(err, data) {
      var article, _i, _len;
      if (err) {
        console.error(err);
        return notify.danger("Initialize Error.Please Reload.");
      }
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        article = data[_i];
        articles.add(new Article(article));
      }
      return Unific.start({
        articles: articles
      });
    });
    socket.on("subscribedFeed", function() {
      return notify.success("New Feed has Subscribed.");
    });
    socket.on("unsubscribedFeed", function() {
      return notify.success("New Feed has Subscribed.");
    });
    return socket.on("newArticle", function(data) {
      console.log(data);
      notify.info(data.page.title);
      return articles.add(data);
    });
  });

}).call(this);
