App.CotizacionNotificarController = Ember.ObjectController.extend({
  needs: ['application','cotizacion'],
  isNotDirty: Ember.computed.not('content.isDirty'),

  actions: {

    notificar: function (cotizacion) {
      self = this;
      var onSuccess = function (cotizacion) {
        self.transitionToRoute('cotizacion', cotizacion);
        self.get('controllers.application').notify('Se notificó cotización');
      };
      var onFail = function (cotizacion) {
        self.get('controllers.application').notify('Error al notificar cotización', 'alert-danger');
      };

      cotizacion.set('status', self.get('controllers.cotizacion.Status.notificado'));

      cotizacion.save().then(onSuccess, onFail);
    }

  }

});