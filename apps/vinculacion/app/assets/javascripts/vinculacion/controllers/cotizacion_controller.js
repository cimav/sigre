App.CotizacionController = Ember.ObjectController.extend({
  needs: ['application','cotizaciones','solicitud'],
  showCotizacion: true,

  Status: {
    edicion:    1,
    notificado: 2,
    aceptado:   3,
    rechazado:  4,
    cancelado:  5
  },

  showRechazado: function(){
    return this.get('isEdicion');
  }.observes('model.status').property('isEdicion'),

  isEdicion: function() {
    return this.get('model.status') == this.get('Status.edicion');
  }.property('model.status'),
  isNotificado: function() {
    return this.get('model.status') == this.get('Status.notificado');
  }.property('model.status'),
  isAceptado: function() {
    return this.get('model.status') == this.get('Status.aceptado');
  }.property('model.status'),
  isRechazado: function() {
    return this.get('model.status') == this.get('Status.rechazado');
  }.property('model.status'),
  isCencelado: function() {
    return this.get('model.status') == this.get('Status.cancelado');
  }.property('model.status')

});

