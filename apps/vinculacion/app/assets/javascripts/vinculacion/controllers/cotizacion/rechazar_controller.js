App.CotizacionRechazarController = Ember.ObjectController.extend({
  needs: ['application','cotizacion', 'cotizaciones'],
  isNotDirty: Ember.computed.not('content.isDirty'),

  actions: {

    recotizar: function (cotizacion) {
      self = this;

      var onSuccess = function (cotizacion) {
        self.get('controllers.application').notify('Recotizar');
        var cotizaciones = self.get('controllers.cotizaciones').get('model');
        self.transitionToRoute('cotizacion', cotizaciones.sortBy('consecutivo').get('lastObject'));
      };

      var onFail = function (cotizacion) {
        self.get('controllers.application').notify('Error al re-cotizar', 'alert-danger');
      };

      cotizacion.set('status', self.get('controllers.cotizacion.Status.rechazado'));
      cotizacion.save().then(onSuccess, onFail);
    }

  }

});