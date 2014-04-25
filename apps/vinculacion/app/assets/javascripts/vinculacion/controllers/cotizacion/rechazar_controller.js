App.CotizacionRechazarController = Ember.ObjectController.extend({
  needs: ['application','cotizacion', 'cotizaciones'],
  isNotDirty: Ember.computed.not('content.isDirty'),

  actions: {

    rechazar: function (cotizacion) {
      self = this;

      var onSuccess = function (cotizacion) {
        self.get('controllers.application').notify('Cotización ' + self.get('consecutivo') + ' rechazada.' );
        
        // Cuando una solicitud se rechaza desde el backend se crea una nueva
        // cotización basada en la rechazada. Es por eso que transicionamos a esta.
        ultimo = self.get('model').get('solicitud.cotizaciones.lastObject');
        self.transitionToRoute('cotizacion', ultimo);
      };

      var onFail = function (cotizacion) {
        self.get('controllers.application').notify('Error al re-cotizar', 'alert-danger');
      };

      cotizacion.set('status', self.get('controllers.cotizacion.Status.rechazado'));
      cotizacion.save().then(onSuccess, onFail);
    }

  }

});