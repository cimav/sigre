App.EmpleadosNewRoute = Ember.Route.extend({
  model: function() {
    //return this.store.createRecord('empleado');
    // FIXME: Debe ser asi ^^^, este es un hack vvvv
    return App.Empleado.createRecord();
  },
  actions: {
    create: function(empleado) {
      empleado.one('didCreate', this, function(){
        this.transitionTo('empleado', empleado);
        this.controllerFor('application').notify('Se agrego nuevo empleado');
      });
      empleado.get('transaction').commit();

    }
  }
});