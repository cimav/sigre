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
  },


  Status: {
    editable: 0,  // Se encuentra en la DB. Es completamenten Editable.
    // Puede solicitar Descuento
    // Si no esta en espera del Descuento, puede pasar a Notifica a Cliente
    espera_descuento: 1,  // En espera que se Autorice el Descuento. (% de descuento autorizado se maneja en cada cotizacion)
    // Una vez autorizado o no el descuento, se pasa a Editable de nuevo.
    cliente_notificado: 2,  // Si esta en editable, se pasa a Notificar Cliente. Se espera por la respuesta. No es editable.
    cliente_acepta: 3,  // El cliente responde aceptando. Se pasa al siguiente Proceso.
    cliente_rechaza: 4,  // El cliente rechaza. Se pasa a Editable o a Crear Nueva a partir de esta.
    // Crear Nueva: se genera el consecutivo y se le asignan los mismos datos (% de descuento autorizado, etc.)
    // El edo de la nueva es Editable
    // El edo de la actual es rechazada
    solicitud_cancelada: 1000 // Si se cancela la Solicitud, la Cotizacion pasa a Cancelada en cualquier Estado.
    // La cotizacion no puede ser cancelada por si misma.
  }
});