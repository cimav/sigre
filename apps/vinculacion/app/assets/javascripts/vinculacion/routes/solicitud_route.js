App.SolicitudRoute = Ember.Route.extend({
  setupController: function(controller, model) {
  	controller.set('content', model);
  	//controller.set('newMuestra', this.store.createRecord('muestra'));
  },
  activate: function() {
    this.controllerFor('solicitudes').set('showSolicitudesList', false);
  },
  deactivate: function() {
    this.controllerFor('solicitudes').set('showSolicitudesList', true);
  }
});