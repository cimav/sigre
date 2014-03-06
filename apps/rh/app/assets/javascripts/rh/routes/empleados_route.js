App.EmpleadosRoute = Ember.Route.extend({
  model: function() {
    this.store.find('empleado');
    return this.store.filter(App.Empleado, function(empleado) {
      return !empleado.get('isNew');
    })
  },
  actions: {
    delete: function(empleado) {
      empleado.destroyRecord();
    }
  }
});