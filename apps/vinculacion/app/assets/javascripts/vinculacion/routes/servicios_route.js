App.ServiciosRoute = Ember.Route.extend({
  setupController: function(controller, model) {
    controller.set('newServicio', this.store.createRecord('servicio'));
  },
  actions: {
    delete: function(servicio) {
      servicio.destroyRecord();
    }
  }
});