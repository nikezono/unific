
/*

 unific.coffee
 */

(function() {
  $(function() {

    /* Configration & Initialize */
    var Unific, articles, articlesView, candidates, candidatesView, httpApi, ioApi, path, refresh, resetCandidates, socket;
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
    socket.on("error", function(err) {
      return notify.danger(err);
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
      model: null,
      collection: candidates
    });
    refresh = function(callback) {
      return httpApi.getLatestArticles(function(err, data) {
        var article, newArticles, _i, _len;
        if (err) {
          console.error(err);
          return notify.danger("Initialize Error.Please Reload.");
        }
        newArticles = [];
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          article = data[_i];
          newArticles.push(new Article(article));
        }
        articles.reset(newArticles);
        $('.collapse').collapse();
        notify.success("Refreshed");
        if (callback) {
          return callback();
        }
      });
    };
    Unific = new Backbone.Marionette.Application();
    Unific.addRegions({
      modals: '#Modals',
      pages: '#Pages'
    });
    Unific.addInitializer(function(options) {
      Unific.pages.show(articlesView);
      Unific.modals.show(candidatesView);
      return $('.collapse').collapse();
    });
    if (!_.isEmpty(path)) {
      refresh(function() {
        return Unific.start();
      });
    }
    socket.on("subscribed", function(data) {
      notify.success("" + data.title + " Subscribed.");
      return refresh();
    });
    socket.on("unsubscribed", function(data) {
      notify.success("" + data.title + " Unsubscribed.");
      return refresh();
    });
    socket.on("newArticle", function(data) {
      notify.info(data.page.title);
      return articles.unshift(new Article(data));
    });
    resetCandidates = function(data) {
      var candidate, newCandidates, _i, _len;
      newCandidates = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        candidate = data[_i];
        newCandidates.push(new Candidate(candidate));
      }
      candidates.reset(newCandidates);
      return $('.modal').modal();
    };
    $('button#Find').click(function() {
      var query;
      query = $('#FindQuery').val();
      return httpApi.findCandidates(query, function(err, data) {
        if (err) {
          return notify.danger(err);
        }
        if (_.isEmpty(data)) {
          return notify.danger("candidate not found");
        }
        return resetCandidates(data);
      });
    });
    return $('button#List').click(function() {
      return httpApi.getFeedList(function(err, data) {
        if (err) {
          return notify.danger(err);
        }
        if (_.isEmpty(data)) {
          return notify.danger("no feed has subscribed");
        }
        return resetCandidates(data);
      });
    });
  });

}).call(this);
