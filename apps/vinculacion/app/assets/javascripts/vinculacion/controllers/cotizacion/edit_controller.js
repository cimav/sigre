App.CotizacionEditController = Ember.ObjectController.extend({
  needs: ['application', 'cotizacion'],

  isNotReadyForSave: function () {
    var result = this.get('content.isDirty') == true && this.get('content.isValid') == true;
    return !result;
  }.property('content.isDirty', 'content.isValid'),

  actions: {

    update: function (cotizacion) {
      self = this;
      var onSuccess = function (cotizacion) {
        self.transitionToRoute('cotizacion');
        self.get('controllers.application').notify('Se actualizó cotización');
      };
      var onFail = function (contacto) {
        self.get('controllers.application').notify('Error al actualizar cotización', 'alert-danger');
      };

      cotizacion.save().then(onSuccess, onFail);
    },

    addDetalle: function(detalle) {
      var detalle = this.get('newDetalle');
      var self = this
      var onSuccess = function(detalle) {
        self.get('controllers.application').notify('Se agrego nuevo detalle');
        var newDetalle = self.store.createRecord('cotizacion_detalle');
        newDetalle.set('cantidad', 1);
        newDetalle.set('precio_unitario', 0);
        self.set('newDetalle', newDetalle);
      };

      var onFail = function(detalle) {
        self.get('controllers.application').notify('Error al agregar detalle', 'alert-danger');
      };
      self.get('controllers.cotizacion').get('model').get('cotizacion_detalles').pushObject(detalle);
      detalle.save().then(onSuccess, onFail);
    }
  }

});