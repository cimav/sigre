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

    var solicitud = this.modelFor('solicitud');
    if (solicitud.get('isTipoIII')) {
      // para los tipo 3 precargar el empleado presupuestal de la solicitud
      // como responsable default del nuevo servicio
      model.set('empleado', solicitud.get('responsable_presupuestal'));
    }

    var muestra = model.get('muestras').get('firstObject');
    controller.set('muestraTipoII', null);
    controller.set('servicioBitacoraTipoII', null);
  }
});