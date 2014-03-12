App.SolicitudRoute = Ember.Route.extend({
  activate: function() {
    this.controllerFor('solicitudes').set('showSolicitudesList', false);
  },
  deactivate: function() {
    this.controllerFor('solicitudes').set('showSolicitudesList', true);
  }
});