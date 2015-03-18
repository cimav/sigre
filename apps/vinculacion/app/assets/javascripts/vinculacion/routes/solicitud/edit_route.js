App.SolicitudEditRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('solicitud');
  },

  afterModel: function(solicitud, transition) {

    if (solicitud.get('tipo') == 1) {

      // precarga la new-muestra si es Solicitud Tipo I
      var newMuestra = solicitud.get('muestras').get('firstObject');
      if (newMuestra == null) {
        newMuestra = this.store.createRecord('muestra');
        newMuestra.set('status', 1);
        newMuestra.set('cantidad', 1);
      }
      this.controllerFor("solicitud_edit").set("newMuestra", newMuestra);

      // precarga el new-servicio es Tipo I
      var servicioBitacora = null;
      var newServicio = solicitud.get('servicios').get('firstObject');
      if (newServicio != null) {
        servicioBitacora = newServicio.get('servicio_bitacora');
      } else {
        servicioBitacora = this.store.getById('servicio_bitacora', 1); // evita la Promise
      }
      solicitud.set("servicioBitacora", servicioBitacora);

    }

  },

  setupController: function(controller, model) {
    controller.set('model', model);

    // asignar el servicioBitacora del modelo al controlador
    controller.set('servicioBitacoraSeleccion', model.get('servicioBitacora'));
  }

});