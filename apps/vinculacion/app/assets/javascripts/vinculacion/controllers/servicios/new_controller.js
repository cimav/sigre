App.ServiciosNewController = Ember.ObjectController.extend({
  needs: ["application", "solicitud"],
  isNotDirty: Ember.computed.not('content.isDirty'),
  actions: {
    submit: function() {
      servicio = this.get('model');
      self = this
      var onSuccess = function(servicio) {
        self.transitionToRoute('servicios');
        self.get('controllers.application').notify('Se agrego nueva servicio');
      };

      var onFail = function(servicio) {
        self.get('controllers.application').notify('Error al agregar servicio', 'alert-danger');
      };
      self.get('controllers.solicitud').get('model').get('servicios').pushObject(servicio);
      servicio.save().then(onSuccess, onFail);
    }
  }
});