App.CotizacionController = Ember.ObjectController.extend({
  needs: ['application', 'cotizaciones', 'solicitud'],
  showCotizacion: true,
  showToolBar: true,

  Status: {
    edicion: 1,
    notificado: 2,
    aceptado: 3,
    rechazado: 4,
    cancelado: 5
  },

  isEdicion: function () {
    return this.get('model.status') == this.get('Status.edicion');
  }.property('model.status'),
  isNotificado: function () {
    return this.get('model.status') == this.get('Status.notificado');
  }.property('model.status')

});

