App.CotizacionesController = Ember.ArrayController.extend({

  nextConsecutivo: function () {
    var cotizaciones = this.get('model');
    var len = 'cotizas.length: ' + cotizaciones.get('length');
    if (len == 0) {
      return 'A';
    } else {
      var letra =  cotizaciones.get('lastObject').get('consecutivo');
      console.log('next ' + letra.next);
      return letra.next;
    }
  },

  createCotizacion: function () {
    var cotizacion = self.store.createRecord('cotizacion', {
      consecutivo: null, //this.nextConsecutivo(), TODO Se va sin consecutivo; es el rails quien se lo asigna.
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

