App.MuestrasRoute = Ember.Route.extend({
  setupController: function(controller, model) {
    controller.set('newMuestra', this.store.createRecord('muestra'));
  },
  actions: {
    delete: function(muestra) {
      muestra.destroyRecord();
    }
  }
});