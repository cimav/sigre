App.SolicitudesNewRoute = Ember.Route.extend({
  activate: function() {
    this.controllerFor('solicitudes').set('showSolicitudesList', false);
  },
  deactivate: function() {
    this.controllerFor('solicitudes').set('showSolicitudesList', true);
  },
  model: function() {
    return this.store.createRecord('solicitud');
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