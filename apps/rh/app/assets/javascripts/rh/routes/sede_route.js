App.SedeRoute = Ember.Route.extend({
  actions: {
    update: function(sede) {
      sede.save();
      this.controllerFor('application').notify('Sede actualizada');
      this.transitionTo('sede');
    }
  }
});