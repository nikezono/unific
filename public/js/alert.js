
/* Alert */

(function() {
  var notify;

  notify = {
    success: function(text) {
      return $.bootstrapGrowl(text, {
        type: 'success',
        allow_dismiss: true,
        align: 'right'
      });
    },
    info: function(text) {
      return $.bootstrapGrowl(text, {
        type: 'info',
        allow_dismiss: true,
        align: 'right'
      });
    },
    danger: function(text) {
      return $.bootstrapGrowl(text, {
        type: 'danger',
        allow_dismiss: true,
        align: 'right'
      });
    }
  };

}).call(this);
