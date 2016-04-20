App.AlertasRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('solicitud').get('alertas');
  },
  setupController: function(controller, model) {
    this._super(controller, model);
  }
});