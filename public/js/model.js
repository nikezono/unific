(function() {
  window.Article = Backbone.Model.extend({
    initialize: function(attr, opts) {
      var timestamp;
      timestamp = new Date(attr.page.pubDate) / 1000;
      return this.set("timestamp", timestamp);
    }
  });

  window.Candidate = Backbone.Model.extend();

  window.Articles = Backbone.Collection.extend(Article);

  window.Candidates = Backbone.Collection.extend(Candidate);

}).call(this);
