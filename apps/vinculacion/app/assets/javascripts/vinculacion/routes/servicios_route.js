App.ServiciosRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('solicitud').get('servicios');
  },
  afterModel: function() {
    this.transitionTo('servicios.resumen');
  }
});