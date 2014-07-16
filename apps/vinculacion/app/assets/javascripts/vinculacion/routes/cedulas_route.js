App.CedulasRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('solicitud');
  },
  afterModel: function (solicitud) {
    var primerCedula = solicitud.get('cedulas').sortBy('codigo').get('firstObject');
    this.transitionTo('cedula', primerCedula);
  }

});