App.SolicitudEditController = Ember.ObjectController.extend({
  needs: ['application'],
  isNotDirty: Ember.computed.not('content.isDirty'),
  actions: {
    submit: function() {
      solicitud = this.get('model');
      self = this;
      var onSuccess = function(solicitud) {
        self.transitionToRoute('solicitud', solicitud);
        self.get('controllers.application').notify('Se actualizó solicitud');
      };

      var onFail = function(solicitud) {
        self.get('controllers.application').notify('Error al actualizar solicitud', 'alert-danger');
      };
      solicitud.save().then(onSuccess, onFail);
    }
  }
});