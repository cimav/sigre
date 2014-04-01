App.MuestrasRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('solicitud').get('muestras');
  },
  setupController: function(controller, model) {
    this._super(controller, model);
    controller.set('newMuestra', this.store.createRecord('muestra'));
  },
  actions: {
    delete: function(muestra) {
      muestra.destroyRecord();
    }
  }
});