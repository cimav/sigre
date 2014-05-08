App.SolicitudesRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('solicitudBusqueda');
//    return this.store.filter(App.SolicitudBusqueda, function(solicitud) {
//      return !solicitud.get('isNew');
//    });
  },

  actions: {
    reload: function () {
      var controller = this.controller;
      this.store.find('solicitudBusqueda').then(function (solicitudes) {
        controller.set('content', solicitudes);
      });
    }
  },

  renderTemplate: function() {
    // FIXME: Corregir bug de back
    this.render({ into: 'application' });
  }
//  setupController: function (controller, model) {
//    controller.set('content', model);
//  },
//  actions: {
//    delete: function(solicitud) {
//      solicitud.destroyRecord();
//    }
//  }
});

