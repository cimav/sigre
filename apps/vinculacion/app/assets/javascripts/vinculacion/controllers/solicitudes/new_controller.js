App.SolicitudesNewController = Ember.ObjectController.extend({
  needs: ["application", 'cotizaciones'],
  isNotDirty: Ember.computed.not('content.isDirty'),
  actions: {
    submit: function() {
      solicitud = this.get('model');
      self = this
      var onSuccess = function(solicitud) {

        // si se crea la Solicitud correctamente, crear y agregar 1era cotizacion por default
        var primeraCotizacion = self.get('controllers.cotizaciones').createCotizacion(); //crea el obj localmente (no en rails)
        self.get('model').get('cotizaciones').pushObject(primeraCotizacion); // el Push inyecta el Solicitud_id
        primeraCotizacion.save(); // el save es quien llama al rails.create

        self.transitionToRoute('solicitud', solicitud);
        self.get('controllers.application').notify('Se agrego nueva solicitud');
      };

      var onFail = function(solicitud) {
        self.get('controllers.application').notify('Error al agregar solicitud', 'alert-danger');
      };

      solicitud.save().then(onSuccess, onFail);
    }
  }
});
