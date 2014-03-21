App.ServicioEditRoute = Ember.Route.extend({
  activate: function() {
    this.controllerFor('servicios').set('showServiciosList', false);
  },
  deactivate: function() {
    this.controllerFor('servicios').set('showServiciosList', true);
  },
  model: function() {
    return this.modelFor('servicio');
  }
});