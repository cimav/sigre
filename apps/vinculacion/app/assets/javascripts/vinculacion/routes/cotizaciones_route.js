App.CotizacionesRoute = Ember.Route.extend({
  needs: ['cotizaciones'],
  model: function () {
    return this.modelFor('solicitud').get('cotizaciones');
  },
  afterModel: function (cotizaciones) {
    this.transitionTo('cotizacion', cotizaciones.sortBy('consecutivo').get('lastObject'));
  }

});

