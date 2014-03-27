App.ServicioEditRoute = Ember.Route.extend({
  activate: function() {
    this.controllerFor('servicio').set('showServicio', false);
  },
  deactivate: function() {
    this.controllerFor('servicio').set('showServicio', true);
  },
  model: function() {
    return this.modelFor('servicio');
  }
});