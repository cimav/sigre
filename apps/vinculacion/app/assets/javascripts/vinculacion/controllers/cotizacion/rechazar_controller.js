App.CotizacionRechazarController = Ember.ObjectController.extend({
  needs: ['application','cotizacion', 'cotizaciones'],
  isNotDirty: Ember.computed.not('content.isDirty'),

  actions: {

    recotizar: function (cotizacion) {
      self = this;

      var onSuccess = function (cotizacion) {
        // clonar
        var clone = self.get('controllers.cotizaciones').cloneCotizacion(cotizacion);
        self.get('controllers.application').notify('Re-cotización: ' + clone.get('consecutivo'));
        self.transitionToRoute('cotizacion', clone);
      };

      var onFail = function (cotizacion) {
        self.get('controllers.application').notify('Error al re-cotizar', 'alert-danger');
      };

      cotizacion.set('status', self.get('controllers.cotizacion.Status.rechazado'));

      cotizacion.save().then(onSuccess, onFail);
    }

//    reeditar: function (cotizacion) {
//      self = this;
//      var onSuccess = function (cotizacion) {
//        self.transitionToRoute('cotizacion', cotizacion);
//        self.get('controllers.application').notify('Se re-editó cotización');
//      };
//      var onFail = function (cotizacion) {
//        self.get('controllers.application').notify('Error al re-editar cotización', 'alert-danger');
//      };
//
//      cotizacion.set('status', self.get('controllers.cotizacion.Status.edicion'));
//
//      cotizacion.save().then(onSuccess, onFail);
//    }

  }

});