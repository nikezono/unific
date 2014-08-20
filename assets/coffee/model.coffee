## Model ##
window.Article   = Backbone.Model.extend
  initialize:(attr,opts)->
    timestamp = new Date(attr.page.pubDate) / 1000
    this.set "timestamp",timestamp

window.Candidate = Backbone.Model.extend()

## Collection ##
window.Articles = Backbone.Collection.extend Article
window.Candidates = Backbone.Collection.extend Candidate

