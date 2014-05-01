App.CotizacionRechazarView = Ember.View.extend({
  didInsertElement: function() {
    $('#cotizacion-rechazar textarea').first().focus();
  }
});