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
      var httpApi, path, subscribed;
      path = window.location.pathname.substr(1);
      httpApi = httpApiWrapper(path);
      subscribed = this.model.attributes.subscribed;
      return httpApi.sendSubscribeEvent({
        action: subscribed ? "unsubscribe" : "subscribe",
        model: this.model.toJSON()
      }, (function(_this) {
        return function(err, data) {
          if (err) {
            return notify.danger(err);
          }
          return _this.model.set("subscribed", !subscribed);
        };
      })(this));
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
