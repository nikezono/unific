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
    url  = attr.url or "http://www.unific.net/#{attr.title}"
    favicon = attr.favicon or "/favicon.ico"
    this.set "name" , name
    this.set "url",url
    this.set "favicon",favicon

## Collection ##
window.Articles = Backbone.Collection.extend Article
window.Candidates = Backbone.Collection.extend Candidate

