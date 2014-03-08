App.MuestraRoute = Ember.Route.extend({
  actions: {
    update: function(muestra) {
      muestra.save();
      this.controllerFor('application').notify('Muestra actualizada');
      this.transitionTo('muestra');
    }
  }
});