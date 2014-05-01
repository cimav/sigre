App.CotizacionAceptarView = Ember.View.extend({
  didInsertElement: function() {
    $('#cotizacion-aceptar textarea').first().focus();
  }
});