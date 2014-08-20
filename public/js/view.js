(function() {
  window.ArticleView = Backbone.Marionette.ItemView.extend({
    template: "#articleTemplate",
    timestamp: function() {
      return this.page.pubDate / 1000;
    }
  });

  window.CandidateView = Backbone.Marionette.ItemView.extend({
    template: "#candidateTemplate"
  });

  window.ArticlesView = Backbone.Marionette.CollectionView.extend({
    childView: ArticleView,
    tagName: 'div',
    className: 'panel-group',
    id: 'accordion'
  });

  window.CandidatesView = Backbone.Marionette.CompositeView.extend({
    childView: CandidateView,
    template: "#candidatesRootTemplate"
  });

}).call(this);
