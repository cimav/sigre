App.CotizacionesController = Ember.ArrayController.extend({

  createCotizacion: function () {
    var cotizacion = self.store.createRecord('cotizacion');
    return cotizacion;
  }

});

