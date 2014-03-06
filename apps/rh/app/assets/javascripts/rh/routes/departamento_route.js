App.DepartamentoRoute = Ember.Route.extend({
  actions: {
    update: function(departamento) {
      departamento.save();
      this.controllerFor('application').notify('Departamento actualizado');
      this.transitionTo('departamento');
    }
  }
});