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
  ui:
    button:"button"
  events:
    "click @ui.button":"sendEvent"

  # Sub/Unsub
  sendEvent:->
    path = (window.location.pathname).substr(1)
    httpApi = httpApiWrapper(path)
    subscribe = this.model.attributes.subscribe
    httpApi.sendSubscribeEvent
      action: if subscribe then "subscribe" else "unsubscribe"
      model: this.model.attributes
    ,(err,data)->
      return notify.danger err if err

  # Helper
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

