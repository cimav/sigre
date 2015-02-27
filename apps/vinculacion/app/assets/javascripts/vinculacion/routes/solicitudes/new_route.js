App.SolicitudesNewRoute = Ember.Route.extend({
  activate: function() {
    this.controllerFor('solicitudes').set('showSolicitudesList', false);
  },
  deactivate: function() {
    this.controllerFor('solicitudes').set('showSolicitudesList', true);
  },
  model: function() {
    var currentUser = this.controllerFor('application').get('currentUser');
    var sede = currentUser.get('sede');
    var proyecto = currentUser.get('proyecto');

    var newSolicitud = this.store.createRecord('solicitud');
    newSolicitud.set('proyecto', proyecto)
    newSolicitud.set('sede', sede);
    newSolicitud.set('prioridad', 1);
    newSolicitud.set('tipo', 1);

    return newSolicitud;
  },
  actions: {
    create: function(solicitud) {
      self = this
      var onSuccess = function(solicitud) {
        self.transitionTo('solicitud', solicitud);
        self.controllerFor('application').notify('Se agregó nueva solicitud');
      };

      var onFail = function(solicitud) {
        self.controllerFor('application').notify('Error al agregar solicitud', 'alert-error');
      };

      solicitud.save().then(onSuccess, onFail);

    }
  }
});