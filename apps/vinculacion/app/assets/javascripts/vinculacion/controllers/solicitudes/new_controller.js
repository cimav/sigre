App.SolicitudesNewController = Ember.ObjectController.extend({
  needs: ["application", 'cotizaciones'],
  isNotDirty: Ember.computed.not('content.isDirty'),
  actions: {
    submit: function() {
      solicitud = this.get('model');
      self = this
      var onSuccess = function(solicitud) {

        // si se crea la Solicitud correctamente, crear y agregar 1era cotizacion por default
        var primeraCotizacion = self.get('controllers.cotizaciones').createCotizacion();
        self.get('model').get('cotizaciones').pushObject(primeraCotizacion);
        primeraCotizacion.save()

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
