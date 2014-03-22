App.ServiciosView = Ember.View.extend({
  didInsertElement: function() {
    $('#servicios-workarea').scrollspy({ target: '#servicios-list' });
  }
});