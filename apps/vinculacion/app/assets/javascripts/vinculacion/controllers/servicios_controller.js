App.ServiciosController = Ember.ArrayController.extend({
  needs: ["application", "solicitud"],
  actions: {
    addServicio: function() {
      var servicio = this.get('newservicio');
      var self = this
      var onSuccess = function(servicio) {
        self.get('controllers.application').notify('Se agrego nuevo servicio');
        self.set('newServicio', self.store.createRecord('servicio'));
      };

      var onFail = function(servicio) {
        self.get('controllers.application').notify('Error al agregar servicio', 'alert-danger');
      };
      self.get('controllers.solicitud').get('model').get('servicios').pushObject(servicio);
      servicio.save().then(onSuccess, onFail);
    }
  }
});