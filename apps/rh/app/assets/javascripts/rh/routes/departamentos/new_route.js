App.DepartamentosNewRoute = Ember.Route.extend({
  model: function() {
    return this.store.createRecord('departamento');
  },
  actions: {
    create: function(departamento) {
      self = this
      var onSuccess = function(departamento) {
        self.transitionTo('departamento', departamento);
        self.controllerFor('application').notify('Se agrego nuevo departamento');
      };

      var onFail = function(departamento) {
        self.controllerFor('application').notify('Error al agregar departamento', 'alert-error');
      };

      departamento.save().then(onSuccess, onFail);
    }
  }
});