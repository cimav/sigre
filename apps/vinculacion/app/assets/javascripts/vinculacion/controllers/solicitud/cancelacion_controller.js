App.SolicitudCancelacionController = Ember.ObjectController.extend({
  needs: ['application'],
  isNotDirty: Ember.computed.not('content.isDirty'),

  actions: {

    cancelar_solicitud: function() {
      solicitud = this.get('model');
      self = this;
      url = '/vinculacion/solicitudes/' + self.get('id') + '/cancelar_solicitud'; // url del controlador en rails
      $.post(url).then(function(response) {
        if (!response.error) {
          self.get('controllers.application').notify('Se cancela solicitud');
          // el controlador en rails pone la solicitud en status = cancelado
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
