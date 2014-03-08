App.SedesNewRoute = Ember.Route.extend({
  model: function() {
    return this.store.createRecord('sede');
  },
  actions: {
    create: function(sede) {
      self = this
      var onSuccess = function(sede) {
        self.transitionTo('sede', sede);
        self.controllerFor('application').notify('Se agrego nueva sede');
      };

      var onFail = function(sede) {
        self.controllerFor('application').notify('Error al agregar sede', 'alert-error');
      };

      sede.save().then(onSuccess, onFail);
    }
  }
});