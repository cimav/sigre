App.SolicitudRoute = Ember.Route.extend({
  activate: function() {
    this.controllerFor('solicitudes').set('showSolicitudesList', false);
  },
  deactivate: function() {
    this.controllerFor('solicitudes').set('showSolicitudesList', true);
  },
  actions: {
    update: function(solicitud) {
      solicitud.save();
      this.controllerFor('application').notify('Solicitud actualizada');
      this.transitionTo('solicitud');
    }
  }
});