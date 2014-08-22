## Model ##
window.Article   = Backbone.Model.extend
  initialize:(attr,opts)->
    timestamp = new Date(attr.page.pubDate) / 1000
    this.set "timestamp",timestamp

window.Candidate = Backbone.Model.extend

  # CandidateはStream/FeedでPolymophicなので
  # ここでViewModelに変換する
  initialize:(attr,opts)->
    host = attr.sitename or "Unific.net"
    name = "#{attr.title} / #{host}"
    favicon = attr.favicon or "/favicon.ico"
    this.set "name" , name
    this.set "favicon",favicon



## Collection ##
window.Articles = Backbone.Collection.extend Article
window.Candidates = Backbone.Collection.extend Candidate

