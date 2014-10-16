
/* Alert */

(function() {
  var html5notification;

  window.notify = {
    success: function(text) {
      html5notification(text);
      return $.bootstrapGrowl(text, {
        ele: "body",
        type: 'success',
        allow_dismiss: true,
        align: 'right'
      });
    },
    info: function(text) {
      html5notification(text);
      return $.bootstrapGrowl(text, {
        ele: "body",
        type: 'info',
        allow_dismiss: true,
        align: 'right'
      });
    },
    danger: function(text) {
      html5notification(text);
      return $.bootstrapGrowl(text, {
        ele: "body",
        type: 'danger',
        allow_dismiss: true,
        align: 'right'
      });
    }
  };

  html5notification = function(text) {
    var show;
    show = function(text) {
      var notification;
      return notification = new Notification("Unific", {
        body: text,
        tag: "test",
        iconUrl: "/images/unific-logo_narrow.png",
        icon: "/images/unific-logo_narrow.png"
      });
    };
    if (window.Notification.permission === "granted") {
      return show(text);
    }
  };

  window.requestPermission = function() {
    if (Notification.permission !== "granted") {
      return Notification.requestPermission();
    } else {
      return notify.info("Notification is already enabled");
    }
  };

}).call(this);
