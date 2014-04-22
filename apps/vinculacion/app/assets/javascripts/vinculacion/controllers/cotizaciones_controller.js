App.CotizacionesController = Ember.ArrayController.extend({
  needs: ['solicitud'],
  sortProperties: ['consecutivo'],
  sortAscending: true
});

