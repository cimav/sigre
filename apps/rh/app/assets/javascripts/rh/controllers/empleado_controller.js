App.EmpleadoController = Ember.ObjectController.extend({
  needs: ["sedes"],
  isNotDirty: Ember.computed.not('content.isDirty'),
  SedeChanged: function() {
    console.log('Cambio de sede...');
  }.observes('sede')
});