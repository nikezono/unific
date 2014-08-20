
/*

 unific.coffee
 */

(function() {
  $(function() {

    /* Configration & Initialize */
    var Unific, articles, articlesView, candidates, candidatesView, httpApi, ioApi, path, socket;
    _.templateSettings = {
      interpolate: /\{\{(.+?)\}\}/g
    };
    path = window.location.pathname.substr(1);
    socket = io("/" + path);
    httpApi = httpApiWrapper(path);
    ioApi = ioApiWrapper(socket);
    socket.on("connect", function() {
      return notify.info("Connected.");
    });
    socket.on("serverError", function(err) {
      console.error(err);
      console.trace();
      return alert.danger("Error");
    });
    articles = new Articles();
    candidates = new Candidates();
    articlesView = new ArticlesView({
      collection: articles
    });
    candidatesView = new CandidatesView({
      collection: candidates
    });
    Unific = new Backbone.Marionette.Application();
    Unific.addRegions({
      modals: '#Modals',
      pages: '#Pages'
    });
    Unific.addInitializer(function(options) {
      Unific.pages.show(articlesView);
      return $('.collapse').collapse();
    });
    if (!_.isEmpty(path)) {
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
        return Unific.start();
      });
    }
    socket.on("subscribedFeed", function() {
      return notify.success("New Feed has Subscribed.");
    });
    socket.on("unsubscribedFeed", function() {
      return notify.success("New Feed has Subscribed.");
    });
    socket.on("newArticle", function(data) {
      notify.info(data.page.title);
      return articles.unshift(new Article(data));
    });
    return socket.on("error", function(err) {
      return notify.danger(err);
    });
  });

}).call(this);
