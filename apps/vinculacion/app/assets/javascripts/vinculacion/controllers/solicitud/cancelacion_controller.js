App.SolicitudCancelacionController = Ember.ObjectController.extend({
  needs: ['application'],
  isNotDirty: Ember.computed.not('content.isDirty'),

  actions: {
    cancelacion: function() {
      solicitud = this.get('model');
      self = this;
      var onSuccess = function(solicitud) {
        self.transitionToRoute('solicitud', solicitud);
        self.get('controllers.application').notify('Se canceló solicitud');
      };

      var onFail = function(solicitud) {
        self.get('controllers.application').notify('Error al cancelar solicitud', 'alert-danger');
      };

      solicitud.set('status', self.get('model').get('Status.cancelada'));
      solicitud.save().then(onSuccess, onFail);
    }
  }

});