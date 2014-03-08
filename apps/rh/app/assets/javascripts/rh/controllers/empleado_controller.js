App.EmpleadoController = Ember.ObjectController.extend({
  needs: ["application"],
  relationshipChanged: false,
  isNotDirty: Ember.computed.not('isDirty'),
  init: function() {
    this.set('sedesCache', this.get('controllers.application.sedesCache'));
    this.set('departamentosCache', this.get('controllers.application.departamentosCache'));
    this.set('empleadosCache', this.get('controllers.application.empleadosCache'));
  },
  SedeChanged: function(empleado) {
    console.log('Sede cambio');
  }.observes('sede')
});