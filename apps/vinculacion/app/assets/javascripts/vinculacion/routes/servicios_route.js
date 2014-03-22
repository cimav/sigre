App.ServiciosRoute = Ember.Route.extend({
  activate: function() {
    console.log('Entro a Servicios');
  },
  deactivate: function() {
    console.log('Salio de Servicios');
  },
  init: function() {
    $('#servicios-workarea').scrollspy({ target: '#servicios-list' });
    console.log('INIT!');
  },
  setupController: function(controller, model) {
    controller.set('newServicio', this.store.createRecord('servicio'));
  },
  actions: {
    delete: function(servicio) {
      servicio.destroyRecord();
    }
  }
});