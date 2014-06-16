App.SolicitudEditController = Ember.ObjectController.extend({
  needs: ['application', 'solicitudes'],
  isNotDirty: Ember.computed.not('content.isDirty'),
  actions: {
    submit: function() {
      solicitud = this.get('model');
      self = this;
      var onSuccess = function(solicitud) {

        // despues de guardar una nueva solicitud
        // recarga la lista de solicitud_busqueda
        self.get('controllers.solicitudes').send('reloadModel');

        self.transitionToRoute('solicitud', solicitud);
        self.get('controllers.application').notify('Se actualizó solicitud');
      };

      var onFail = function(solicitud) {
        self.get('controllers.application').notify('Error al actualizar solicitud', 'alert-danger');
      };
      solicitud.save().then(onSuccess, onFail);
    }
  }
});