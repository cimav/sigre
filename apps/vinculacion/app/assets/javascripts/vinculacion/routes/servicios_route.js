App.ServiciosRoute = Ember.Route.extend({
  afterModel: function() {
    this.transitionTo('servicios.resumen');
  }
});