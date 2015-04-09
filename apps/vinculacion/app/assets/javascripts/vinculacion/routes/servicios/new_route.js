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

    var muestra = model.get('muestras').get('firstObject');
    controller.set('muestraTipoII', null);
    controller.set('servicioBitacoraTipoII', null);
  }
});