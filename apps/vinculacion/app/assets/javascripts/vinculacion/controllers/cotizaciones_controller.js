App.CotizacionesController = Ember.ArrayController.extend({

  nextConsecutivo: function () {
    var cotizaciones = this.get('model');
    console.log('cotizas: ' + cotizaciones);
    console.log('cotizas.length: ' + cotizaciones.length);
    if (cotizaciones.length === 0) {
      return 'A';
    } else {
      return cotizaciones.get('lastObject').get('consecutivo').next;
    }
  },

  createCotizacion: function () {
    var cotizacion = self.store.createRecord('cotizacion', {
      consecutivo: this.nextConsecutivo(),
      fecha_notificacion: new Date(),
      condicion: 1,
      idioma: 1,
      divisa: 1,
      comentarios: 'Comentarios default',
      observaciones: 'Observaciones Default',
      notas: 'Notas default',
      subtotal: 0.00,
      precio_venta: 0.00,
      precio_unitario: 0.00,
      descuento_porcentaje: 0.00,
      descuento_status: 0,
      status: 0
    });
    return cotizacion;
  }

});

