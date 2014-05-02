App.CotizacionDetalleController = Ember.ObjectController.extend({
  needs: ['application','cotizacion'],
  isNotDirty: Ember.computed.not('content.isDirty'),
  actions: {
    deleteDetalle: function(detalle) {
      var self = this;
      self.get('controllers.cotizacion').get('model').send('becomeDirty');
      var onSuccess = function (detalle) {
        self.get('controllers.application').notify('Se eliminó detalle');
      };
      var onFail = function (detalle) {
        self.get('controllers.application').notify('Error al eliminar detalle', 'alert-danger');
      };
      detalle.deleteRecord();
      detalle.save().then(onSuccess, onFail);
    }
  },

  saveDetalle: function() {
    if (this.get('model.isDirty')) {
      var item = this.get('model');
      var self = this;
      var onSuccess = function(item) {
        self.get('controllers.cotizacion').get('model').send('becomeDirty');
        self.get('controllers.application').notify('Se actualizó el detalle');
      };

      var onFail = function(item) {
        self.get('controllers.application').notify('Error al actualizar detalle', 'alert-danger');
      };
      item.save().then(onSuccess, onFail);
    }
  },

  autoSave: function() {
    Ember.run.debounce(this, this.saveDetalle, 1000); 
  }.observes('content.isDirty')


});