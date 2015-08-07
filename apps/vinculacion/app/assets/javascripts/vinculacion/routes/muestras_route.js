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
    },
    reloadModel: function () {
      var controller = this.controller;
      var sol_id = this.modelFor('solicitud').get('id');
      this.store.find('muestra', {solicitud_id : sol_id} ).then(function (muestras) {
        controller.set('content', muestras);
      });
    }
  }
});