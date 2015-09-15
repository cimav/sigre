App.CotizacionesController = Ember.ArrayController.extend({
  needs: ['solicitud', 'cotizaciones'],
  sortProperties: ['consecutivo'],
  sortAscending: true,

  actions: {
    reloadModel: function () {
      var solicitud = this.get('controllers.solicitud');
      this.store.find('cotizacion', {solicitud_id: solicitud.get('id')}).then(function (cotizaciones) {
        solicitud.set('cotizaciones', cotizaciones);
      });
    }
  }

});


