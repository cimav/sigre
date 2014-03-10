App.EmpleadoController = Ember.ObjectController.extend({
  needs: ["application"],
  isNotDirty: Ember.computed.not('isDirty'),
  SedeChanged: function(empleado) {
    console.log('Sede cambio');
  }.observes('sede')
});