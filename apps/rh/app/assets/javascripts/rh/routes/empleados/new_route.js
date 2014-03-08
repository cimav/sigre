App.EmpleadosNewRoute = Ember.Route.extend({
  model: function() {
    return this.store.createRecord('empleado');
  },
  actions: {
    create: function(empleado) {
     self = this
      var onSuccess = function(empleado) {
        self.transitionTo('empleado', empleado);
        self.controllerFor('application').notify('Se agrego nuevo empleado');
      };

      var onFail = function(empleado) {
        self.controllerFor('application').notify('Error al agregar empleado', 'alert-error');
      };

      empleado.save().then(onSuccess, onFail);
    }
  }
});