window.ArticleView = Backbone.Marionette.ItemView.extend
  template:"#articleTemplate"

window.ArticlesView = Backbone.Marionette.CollectionView.extend
  childView:ArticleView
  tagName:'div'
  className:'panel-group'
  id:'accordion'

window.CandidateView = Backbone.Marionette.ItemView.extend
  template:"#candidateTemplate"
  modelEvents:
    change: "render"
  templateHelpers:
    renderButton:(subscribed)->
      if subscribed
        return "
        <button class='btn btn-warning'>
          <span class='glyphicon glyphicon-minus'>
            Unsubscribe
          </span>
        </button>
        "
      else
        return "
        <button class='btn btn-primary'>
          <span class='glyphicon glyphicon-plus'>
            Subscribe
          </span>
        </button>
        "

window.CandidatesView = Backbone.Marionette.CompositeView.extend
  template:"#candidatesRootTemplate"
  childView:CandidateView
  childViewContainer:"ol"

