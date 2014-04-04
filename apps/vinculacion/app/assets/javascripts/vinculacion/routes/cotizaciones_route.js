App.CotizacionesRoute = Ember.Route.extend({
  model: function () {
    return this.modelFor('solicitud').get('cotizaciones');
  },
  afterModel: function (cotizaciones) {
    this.transitionTo('cotizacion', cotizaciones.get('lastObject'));
  }
});
