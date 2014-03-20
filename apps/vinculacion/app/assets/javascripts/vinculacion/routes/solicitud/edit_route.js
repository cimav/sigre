App.SolicitudEditRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('solicitud');
  }
});