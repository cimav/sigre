App.CotizacionSolicitarDescuentoController = Ember.ObjectController.extend({
  needs: ['application','cotizacion'],
  isNotDirty: Ember.computed.not('content.isDirty'),

  actions: {

    solicitar_descuento: function (cotizacion) {
      self = this;
      var descuento_solicitado = self.get('controllers.cotizacion').get('Status.descuento_solicitado');
      cotizacion.set('status', descuento_solicitado);
      var onSuccess = function(cotizacion) {
        self.get('controllers.application').notify('Descuento solicitado');
        self.transitionToRoute('cotizacion', cotizacion);
      };
      var onFail = function(cotizacion) {
        self.get('controllers.application').notify('Error al solicitar descuento', 'alert-danger');
      };
      cotizacion.save().then(onSuccess, onFail);
    }
  }

});

