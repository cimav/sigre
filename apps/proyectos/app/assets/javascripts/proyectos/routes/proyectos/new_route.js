App.ProyectosNewRoute = Ember.Route.extend({
  model: function() {
    return this.store.createRecord('proyecto');
  },
  actions: {
    create: function(proyecto) {
      self = this;
      var onSuccess = function(proyecto) {
        self.transitionTo('proyecto', proyecto);
        self.controllerFor('application').notify('Se agregó nueva proyecto');
      };

      var onFail = function(proyecto) {
        self.controllerFor('application').notify('Error al agregar proyecto', 'alert-error');
      };

      proyecto.save().then(onSuccess, onFail);

    }
  }

});
