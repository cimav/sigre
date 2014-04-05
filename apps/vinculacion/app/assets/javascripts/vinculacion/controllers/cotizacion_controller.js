App.CotizacionController = Ember.ObjectController.extend({
  needs: ['application','cotizaciones','solicitud'],
  showCotizacion: true,

  nueva: function() {
    // clonar cotizacion
    var cotizacion = this.get('controllers.cotizaciones').createCotizacion();
    // campos clonados
    cotizacion.set('condicion', this.get('model.condicion'));
    cotizacion.set('idioma', this.get('model.idioma'));
    cotizacion.set('divisa', this.get('model.divisa'));
    cotizacion.set('comentarios', this.get('model.comentarios'));
    cotizacion.set('observaciones', this.get('model.observaciones'));
    cotizacion.set('notas', this.get('model.notas'));
    cotizacion.set('subtotal', this.get('model.subtotal'));
    cotizacion.set('precio_venta', this.get('model.precio_venta'));
    cotizacion.set('precio_unitario', this.get('model.precio_unitario'));
    cotizacion.set('descuento_porcentaje', this.get('model.descuento_porcentaje'));
    cotizacion.set('descuento_status', this.get('model.descuento_status'));
    // campos cambiados
    // consecutivo asignado en la creacion
    // status en Editable
    cotizacion.set('status', this.status_array[0].id);

    // agregar la cotizacion clonada a la solicitud
    this.get('controllers.solicitud').addCotizacion(cotizacion);
  },

  status_array: [
    {id: 0, text: 'Editable'},
    {id: 1, text: 'Notificada'},
    {id: 2, text: 'Aceptada'},
    {id: 3, text: 'Rechazada'},
    {id: 4, text: 'Cancelada'},
    {id: 5, text: 'Nueva'}
  ],

  statusObserver: function() {
    switch (this.get('model.statusChanged')) {
      case 5:
          this.nueva();
          break;
      default:
           break;
    }
  }.observes('model.statusChanged')




});

