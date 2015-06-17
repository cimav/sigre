App.ApplicationView = Ember.View.extend({
  classNames: ['application-view'],
  willInsertElement: function() {
    $("#loading").remove();
  }
});
