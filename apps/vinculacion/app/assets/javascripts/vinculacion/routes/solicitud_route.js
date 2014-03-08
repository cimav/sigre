App.SolicitudRoute = Ember.Route.extend({
  actions: {
    update: function(solicitud) {
      solicitud.save();
      this.controllerFor('application').notify('Solicitud actualizada');
      this.transitionTo('solicitud');
    }
  }
});