App.CotizacionDetalleController = Ember.ObjectController.extend({
  needs: ['application'],
  isNotDirty: Ember.computed.not('content.isDirty'),
  actions: {
    deleteDetalle: function(detalle) {
      console.log('XXX');
      var appController = this.get('controllers.application');
      var onSuccess = function (detalle) {
        appController.notify('Se eliminó detalle');
      };
      var onFail = function (detalle) {
        appController.notify('Error al eliminar detalle', 'alert-danger');
      };
      //$('#detalle_').fadeOut(200, function() {
        detalle.deleteRecord();
        detalle.save().then(onSuccess, onFail);
      //});
    },

    updateDetalle: function() {
      item = this.get('model');
      self = this;
      var onSuccess = function(item) {
        self.get('controllers.application').notify('Se actualizó el detalle');
      };

      var onFail = function(item) {
        self.get('controllers.application').notify('Error al actualizar detalle', 'alert-danger');
      };
      item.save().then(onSuccess, onFail);
    }
  },

  saveDetalle: function() {
    if (this.get('model.isDirty')) {
      console.log('SAVE DETALLE ' + this.get('model.id') );  
     
      item = this.get('model');
      self = this;
      var onSuccess = function(item) {
        self.get('controllers.application').notify('Se actualizó el detalle');
      };

      var onFail = function(item) {
        self.get('controllers.application').notify('Error al actualizar detalle', 'alert-danger');
      };
      item.save().then(onSuccess, onFail);
    }
  },

  autoSave: function() {
    console.log('AUTO SAVE!');
    Ember.run.debounce(this, this.saveDetalle, 1000); 
  }.observes('content.isDirty')


});