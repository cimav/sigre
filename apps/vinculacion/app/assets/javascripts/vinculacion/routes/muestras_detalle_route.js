App.MuestrasDetalleRoute = Ember.Route.extend({

  model: function () {
    this.modelFor('muestra').get('muestras_detalle');
  }

});