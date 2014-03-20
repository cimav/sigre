App.EmpleadosRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('empleado');
      },
  actions: {
    delete: function(empleado) {
      empleado.destroyRecord();
    }
  }
});