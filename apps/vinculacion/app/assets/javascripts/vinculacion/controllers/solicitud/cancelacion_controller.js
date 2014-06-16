App.SolicitudCancelacionController = Ember.ObjectController.extend({
  needs: ['application'],
  isNotDirty: Ember.computed.not('content.isDirty'),

  actions: {

    cancelar_solicitud: function() {
      // guardar razon y motivo status
      // guardar status = cancelado
      solicitud = this.get('model');
      self = this;
      var onSuccess = function(solicitud) {
        self.transitionToRoute('solicitud', solicitud);
        self.get('controllers.application').notify('Se canceló solicitud');

        // 2do, notifica la cancelacion a la bitacora
        self.send('notificar_cancelacion', solicitud);
      };
      var onFail = function(solicitud) {
        self.get('controllers.application').notify('Error al cancelar solicitud', 'alert-danger');
      };
      // pone en Cancelada la solicitud
      solicitud.set('status', self.get('model').get('Status.cancelada'));
      // 1ero guarda y cancela en Vinculacion
      solicitud.save().then(onSuccess, onFail);
    },

    notificar_cancelacion: function(solicitud) {
      // notificar a bitacora a través del request bus
      self = this;
      url = '/vinculacion/solicitudes/' + self.get('id') + '/notificar_cancelacion'; // url del controlador en rails
      $.post(url).then(function(response) {
        if (!response.error) {
          self.get('controllers.application').notify('Se notificó cancelación a Bitácora');
          self.transitionToRoute('solicitud', solicitud);
        } else {
          console.log('ERROR');
          console.log(response);
          self.get('controllers.application').notify('Error al cancelar solicitud', 'alert-danger');
        }
      });
    }


  }

});
