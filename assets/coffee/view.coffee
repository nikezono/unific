window.ArticleView = Backbone.Marionette.ItemView.extend
  template:"#articleTemplate"

window.ArticlesView = Backbone.Marionette.CollectionView.extend
  childView:ArticleView
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
    subscribed = this.model.attributes.subscribed
    httpApi.sendSubscribeEvent
      action: if subscribed then "unsubscribe" else "subscribe"
      model: this.model.toJSON()
    ,(err,data)=>
      return notify.danger err if err
      # 成功した場合反転
      this.model.set "subscribed", !subscribed

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

