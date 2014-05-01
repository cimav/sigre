App.CotizacionNotificarView = Ember.View.extend({
  didInsertElement: function() {
    $('#cotizacion-notificar textarea').first().focus();
  }
});