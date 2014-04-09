App.CotizacionesController = Ember.ArrayController.extend({
  needs: ['solicitud'],

  sortProperties: ['consecutivo'],
  sortAscending: true,

  createCotizacion: function () {
    var cotiza = self.store.createRecord('cotizacion');
    self.get('model').get('cotizaciones').pushObject(cotiza); // funciona con self, no con this.
    cotiza.save();
    return cotiza;
  },

  cloneCotizacion: function (cotizacion) {

    if (cotizacion.get('status') != self.get('controllers.cotizacion.Status.rechazado')) {
      // la actual debe estar en Rechazado
      return;
    }

    // crear cotizacion clon vacia
    var clone = self.store.createRecord('cotizacion');
    this.get('model').pushObject(clone);
    // clonar
    clone.set('consecutivo', cotizacion.get('consecutivo'));
    clone.set('condicion', cotizacion.get('condicion'));
    clone.set('idioma', cotizacion.get('idioma'));
    clone.set('divisa', cotizacion.get('divisa'));
    clone.set('comentarios', cotizacion.get('comentarios'));
    clone.set('observaciones', cotizacion.get('observaciones'));
    clone.set('notas', cotizacion.get('notas'));
    clone.set('subtotal', cotizacion.get('subtotal'));
    clone.set('precio_venta', cotizacion.get('precio_venta'));
    clone.set('precio_unitario', cotizacion.get('precio_unitario'));
    clone.set('descuento_porcentaje', cotizacion.get('descuento_porcentaje'));
    clone.set('descuento_status', cotizacion.get('descuento_status'));
    clone.save();

    //self.transitionToRoute('cotizacion', this.get('model').sortBy('consecutivo').get('lastObject'));

    return clone;
  }

});

