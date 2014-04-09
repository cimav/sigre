App.CotizacionAceptarController = Ember.ObjectController.extend({
  needs: ['application','cotizacion'],
  isNotDirty: Ember.computed.not('content.isDirty'),
  actions: {

    aceptar: function (cotizacion) {
      self = this;
      var onSuccess = function (cotizacion) {
        self.transitionToRoute('cotizacion', cotizacion);
        self.get('controllers.application').notify('Se aceptó cotización');
      };
      var onFail = function (cotizacion) {
        self.get('controllers.application').notify('Error al aceptar cotización', 'alert-danger');
      };

      cotizacion.set('status', self.get('controllers.cotizacion.Status.aceptado'));

      cotizacion.save().then(onSuccess, onFail);
    }

  }

});