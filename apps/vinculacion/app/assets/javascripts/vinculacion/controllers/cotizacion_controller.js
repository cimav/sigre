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
    descuento_solicitado: 5,
    descuento_aceptado: 6,
    descuento_rechazado: 7,
    cancelado: 99
  },

  actions: {
    recotizar: function(cotizacion) {
      self = this;
      var onSuccess = function (cotizacion) {
        self.transitionToRoute('cotizacion');
        self.get('controllers.application').notify('Recotizar');
      };
      var onFail = function (contacto) {
        self.get('controllers.application').notify('Error al recotizar', 'alert-danger');
      };
      // si un descuento es rechazado, puede re-editar la cotizacion
      cotizacion.set('status', self.get('Status.edicion'));
      cotizacion.save().then(onSuccess, onFail);
      this.transitionToRoute('cotizacion');
    }
  },

  isEdicion: function() {
    return true;// this.get('model.status') == this.get('Status.edicion');
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

  isCancelado: function() {
    return this.get('model.status') == this.get('Status.cancelado');
  }.property('model.status'),

  isDescuentoSolicitado: function() {
    return this.get('model.status') == this.get('Status.descuento_solicitado');
  }.property('model.status'),

  isSolicitarDescuento: function() {
    var isEdicion = this.get('isEdicion');
    var isPorcenMayor = this.get('model.descuento_porcentaje') > 0;
    var isDescuentoSolicitado = this.get('isDescuentoSolicitado');

    var result =  isEdicion && isPorcenMayor && !isDescuentoSolicitado;

    return result;
  }.property('model.descuento_porcentaje'),

  isDescuentoAceptado: function() {
    result = this.get('model.status') == this.get('Status.descuento_aceptado');
    return result;
  }.property('model.status'),

  isDescuentoRechazado: function() {
    result = this.get('model.status') == this.get('Status.descuento_rechazado');
    return result;
  }.property('model.status'),

  noPuedeNotificar: function() {
    return this.get('model.subtotal_calculado') <= 0;
  }.property('model.subtotal_calculado'),

  pdf_url: function() {
    return '/vinculacion/cotizacion/' + this.get('id') + '/pdf';
  }.property('model.id'),

  disablePDFCotizacion: function() {
    var result = this.get('isEdicion') || this.get('isDescuentoSolicitado') || this.get('isDescuentoRechazado');
    result = false;
    return result;
  }.property('status')

});

