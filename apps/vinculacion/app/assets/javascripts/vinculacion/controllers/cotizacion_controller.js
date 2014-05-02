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
    cancelado: 5,
    descuento_solicitado: 6,
    descuento_aceptado: 7,
    descuento_rechazado: 8
  },

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

  isDescuentoSolicitado: function() {
    return this.get('model.status') == this.get('Status.descuento_solicitado');
  }.property('model.status'),

  isNotAllowAutorizarDescuento: function () {
    var isEdicion = this.get('isEdicion');
    var isPorcenMayor = this.get('model.descuento_porcentaje') > 0;
    var isDescuentoSolicitado = this.get('isDescuentoSolicitado');

    var result =  isEdicion && isPorcenMayor && !isDescuentoSolicitado;

    return !result;
  }.property('model.descuento_porcentaje'),

  isNotAllowNotificar: function() {
    result = !this.get('isNotAllowAutorizarDescuento');
    result = result || this.get('model.subtotal_calculado') <= 0;
    return result;
  }.property('model.descuento_porcentaje', 'model.subtotal_calculado'),

  isDescuentoAceptado: function() {
    result = this.get('model.status') == this.get('Status.descuento_aceptado');
    return result;
  }.property('model.status'),

  actions: {
    autorizar_descuento: function() {
      self = this;
      self.set('model.status', this.get('Status.descuento_solicitado'));
      var onSuccess = function(cotizacion) {
        self.get('controllers.application').notify('Descuento solicitado');
      };
      var onFail = function(cotizacion) {
        self.get('controllers.application').notify('Error al solicitar descuento', 'alert-danger');
      };
      self.get('model').save().then(onSuccess, onFail);
    }
  },

//  noPuedeNotificar: function() {
//    return this.get('model.subtotal_calculado') <= 0;
//  }.property('model.subtotal_calculado')

});

