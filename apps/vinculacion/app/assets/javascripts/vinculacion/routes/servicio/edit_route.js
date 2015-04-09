App.ServicioEditRoute = Ember.Route.extend({
  activate: function() {
    this.controllerFor('servicio').set('showServicio', false);
  },
  deactivate: function() {
    this.controllerFor('servicio').set('showServicio', true);
  },
  model: function() {
    return this.modelFor('servicio');
  },
  setupController: function(controller, model) {
    controller.set('model', model);

    // asignar muestra y servicioBitacora del modelo al controlador
    var muestra = model.get('muestras').get('firstObject');
    controller.set('muestraTipoII', muestra);
    controller.set('servicioBitacoraTipoII', model.get('servicio_bitacora'));
  }

});