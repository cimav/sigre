App.CotizacionSolicitarDescuentoView = Ember.View.extend({
  didInsertElement: function() {
    $('#cotizacion-solicitar-descuento textarea').first().focus();
  }
});