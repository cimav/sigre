App.SolicitudesNewController = Ember.ObjectController.extend({
  needs: ["application", 'cotizaciones', 'solicitudes'],
  isNotDirty: Ember.computed.not('content.isDirty'),
  actions: {
    submit: function() {
      solicitud = this.get('model');
      self = this
      var onSuccess = function(solicitud) {

        // despues de guardar una nueva solicitud
        // recarga la lista de solicitud_busqueda
        self.get('controllers.solicitudes').send('reloadModel');

        if(solicitud.get('is_coordinado')) {
          self.transitionToRoute('solicitud', solicitud);
        } else {
          self.transitionToRoute('solicitud.edit', solicitud); // directo a editar
        }
        self.get('controllers.application').notify('Se agrego nueva solicitud');
      };

      var onFail = function(solicitud) {
        self.get('controllers.application').notify('Error al agregar solicitud', 'alert-danger');
      };

      solicitud.save().then(onSuccess, onFail);
    }
  }
});
