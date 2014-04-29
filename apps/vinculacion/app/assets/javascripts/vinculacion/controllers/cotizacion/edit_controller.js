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
    }

  }

});