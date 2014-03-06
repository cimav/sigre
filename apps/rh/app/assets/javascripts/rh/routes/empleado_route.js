App.EmpleadoRoute = Ember.Route.extend({
  actions: {
    update: function(empleado) {
      empleado.save();
      this.controllerFor('application').notify('Empleado actualizado');
      this.transitionTo('empleado');
    }
  }
});