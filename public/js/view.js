(function() {
  window.ArticleView = Backbone.Marionette.ItemView.extend({
    template: "#articleTemplate"
  });

  window.ArticlesView = Backbone.Marionette.CollectionView.extend({
    childView: ArticleView,
    tagName: 'div',
    className: 'panel-group',
    id: 'accordion'
  });

  window.CandidateView = Backbone.Marionette.ItemView.extend({
    template: "#candidateTemplate",
    modelEvents: {
      change: "render"
    },
    ui: {
      button: "button"
    },
    events: {
      "click @ui.button": "sendEvent"
    },
    sendEvent: function() {
      var httpApi, path, subscribe;
      path = window.location.pathname.substr(1);
      httpApi = httpApiWrapper(path);
      subscribe = this.model.attributes.subscribe;
      return httpApi.sendSubscribeEvent({
        action: subscribe ? "subscribe" : "unsubscribe",
        model: this.model.attributes
      }, function(err, data) {
        if (err) {
          return notify.danger(err);
        }
      });
    },
    templateHelpers: {
      renderButton: function(subscribed) {
        if (subscribed) {
          return "<button class='btn btn-warning'> <span class='glyphicon glyphicon-minus'> Unsubscribe </span> </button>";
        } else {
          return "<button class='btn btn-primary'> <span class='glyphicon glyphicon-plus'> Subscribe </span> </button>";
        }
      }
    }
  });

  window.CandidatesView = Backbone.Marionette.CompositeView.extend({
    template: "#candidatesRootTemplate",
    childView: CandidateView,
    childViewContainer: "ol"
  });

}).call(this);
