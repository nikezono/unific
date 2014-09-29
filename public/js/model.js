(function() {
  window.Article = Backbone.Model.extend({
    initialize: function(attr, opts) {
      var timestamp;
      timestamp = new Date(attr.page.pubDate) / 1000;
      return this.set("timestamp", timestamp);
    }
  });

  window.Candidate = Backbone.Model.extend({
    initialize: function(attr, opts) {
      var favicon, host, name, url;
      host = attr.sitename || "Unific.net";
      name = "" + attr.title + " / " + host;
      url = attr.url || ("http://www.unific.net/" + attr.title);
      favicon = attr.favicon || "/favicon.ico";
      this.set("name", name);
      this.set("url", url);
      return this.set("favicon", favicon);
    }
  });

  window.Articles = Backbone.Collection.extend(Article);

  window.Candidates = Backbone.Collection.extend(Candidate);

}).call(this);
