App.SolicitudesRoute = Ember.Route.extend({
  model: function () {
    return this.store.find('solicitudBusqueda');
  },

  actions: {
    reloadModel: function () {
      var controller = this.controller;
      this.store.find('solicitudBusqueda').then(function (solicitudes) {
        controller.set('content', solicitudes);
      });
    }
  },

  renderTemplate: function () {
    // FIXME: Corregir bug de back
    this.render({ into: 'application' });
  }
});

