
/*

 unific.coffee
 */

(function() {
  $(function() {

    /* Configration & Initialize */
    var Unific, articles, articlesView, candidates, candidatesView, collapseCount, httpApi, ioApi, path, refresh, refreshCollapse, resetCandidates, socket, time;
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
    time = null;
    collapseCount = 0;
    refresh = function(callback) {
      if (!(time === null || (new Date() / 1 - time / 1) > 1000 * 60 * 3)) {
        return;
      }
      time = new Date();
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
        notify.success("Refreshed");
        if (callback) {
          return callback();
        }
      });
    };
    refreshCollapse = function() {
      $('.collapse').collapse('hide');
      $($('#accordion').find('.panel')[collapseCount]).find('.collapse').collapse('hide');
      collapseCount = 0;
      return $($('#accordion').find('.panel')[collapseCount]).find('.collapse').collapse('show');
    };
    Unific = new Backbone.Marionette.Application();
    Unific.addRegions({
      modals: '#Modals',
      pages: '#Pages'
    });
    Unific.addInitializer(function(options) {
      Unific.pages.show(articlesView);
      return Unific.modals.show(candidatesView);
    });
    if (!_.isEmpty(path)) {
      refresh(function() {
        Unific.start();
        return refreshCollapse();
      });
    }
    document.addEventListener("visibilitychange", function() {
      if (!document.hidden) {
        return refresh();
      }
    });
    socket.on('reconnect', function() {
      return refresh(function() {
        return refreshCollapse();
      });
    });
    socket.on("subscribed", function(data) {
      notify.success("" + data.title + " Subscribed.");
      return refresh(function() {
        return refreshCollapse();
      });
    });
    socket.on("unsubscribed", function(data) {
      notify.success("" + data.title + " Unsubscribed.");
      return refresh(function() {
        return refreshCollapse();
      });
    });
    socket.on("newArticle", function(data) {
      notify.info(data.page.title);
      return articles.unshift(new Article(data));
    });
    $(window).keyup(function(e) {
      var $after, $before;
      if (_.contains([39, 40, 34, 32, 13, 45], e.keyCode)) {
        $before = $($('#accordion').find('.panel')[collapseCount]).find('.collapse').collapse('hide');
        if ($('#accordion').find('.panel').length > collapseCount) {
          collapseCount += 1;
        }
        $after = $($('#accordion').find('.panel')[collapseCount]).find('.collapse').collapse('show');
        $("html, body").animate({
          scrollTop: $before.offset().top - 40
        }, 200);
        return true;
      } else if (_.contains([37, 38, 33, 8, 35], e.keyCode)) {
        $before = $($('#accordion').find('.panel')[collapseCount]).find('.collapse').collapse('hide');
        if (collapseCount > 0) {
          collapseCount -= 1;
        }
        $after = $($('#accordion').find('.panel')[collapseCount]).find('.collapse').collapse('show');
        $("html, body").animate({
          scrollTop: $after.offset().top - 40
        }, 200);
        return true;
      }
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
    $('button#List').click(function() {
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
    $('button#Hot').click(function() {
      return notify.danger("未実装");
    });
    return $('button#Fork').click(function() {
      return notify.danger("未実装");
    });
  });

}).call(this);
