App.CotizacionController = Ember.ObjectController.extend({
  needs: ['application', 'cotizaciones', 'solicitud'],
  showCotizacion: true,
  showToolBar: true,
  condicion_item: App.computed.list_item('condicion'),
  idioma_item: App.computed.list_item('idioma'),
  divisa_item: App.computed.list_item('divisa'),

  Status: {
    edicion: 1,
    notificado: 2,
    aceptado: 3,
    rechazado: 4,
    cancelado: 5
  },

  status_text: [
    {id: 1, texto: 'Edición'},
    {id: 2, texto: 'Notificado'},
    {id: 3, texto: 'Aceptado'},
    {id: 4, texto: 'Rechazado'},
    {id: 5, texto: 'Cancelado'}
  ],

  isEdicion: function () {
    return this.get('model.status') == this.get('Status.edicion');
  }.property('model.status'),
  isNotificado: function () {
    return this.get('model.status') == this.get('Status.notificado');
  }.property('model.status')

});

