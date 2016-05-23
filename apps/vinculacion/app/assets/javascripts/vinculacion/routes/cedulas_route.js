App.CedulasRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('solicitud');
  },
  afterModel: function (solicitud) {
    var cedulas = solicitud.get('cedulas');
    if (!Ember.isEmpty(cedulas)) {
      var primerCedula = cedulas.sortBy('codigo').get('firstObject');
      this.transitionTo('cedula', primerCedula);
    }
  },

  actions: {
    reloadCedula: function (cedula) {
      this.refresh();
    }
  }

});