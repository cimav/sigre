App.ServiciosNewRoute = Ember.Route.extend({
  activate: function() {
  },
  deactivate: function() {
  },
  model: function() {
    return this.store.createRecord('servicio');
  },
  setupController: function(controller, model) {
    controller.set('content', model);
  },
});