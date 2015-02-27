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
        self.get('model').get('solicitud').reload().then(function (solicitud) {
          var ultima = solicitud.get('cotizaciones.lastObject');
          self.transitionToRoute('cotizacion', ultima);
        });

      };

      var onFail = function (cotizacion) {
        self.get('controllers.application').notify('Error al re-cotizar', 'alert-danger');
      };

      // al poner status=rechazado, el backend crea una nueva cotización
      cotizacion.set('status', self.get('controllers.cotizacion.Status.rechazado'));
      cotizacion.save().then(onSuccess, onFail);
    }

  }

});