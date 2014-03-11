App.EmpleadoController = Ember.ObjectController.extend({
  needs: ["application"],
  isNotDirty: Ember.computed.not('isDirty')
});