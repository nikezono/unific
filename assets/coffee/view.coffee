window.ArticleView = Backbone.Marionette.ItemView.extend
  template:"#articleTemplate"

window.ArticlesView = Backbone.Marionette.CollectionView.extend
  childView:ArticleView
  tagName:'div'
  className:'panel-group'
  id:'accordion'

window.CandidateView = Backbone.Marionette.ItemView.extend
  template:"#candidateTemplate"

window.CandidatesView = Backbone.Marionette.CompositeView.extend
  template:"#candidatesRootTemplate"
  childView:CandidateView
  childViewContainer:"ol"

