App.SolicitudesRoute = Ember.Route.extend({
  model: function() {
    this.store.find('solicitud');
    return this.store.filter(App.Solicitud, function(solicitud) {
      return !solicitud.get('isNew');
    });
  },
  renderTemplate: function() {
    // FIXME: Corregir bug de back
    this.render({ into: 'application' });
  },
  setupController: function (controller, model) {
    controller.set('content', model);
  },
  actions: {
    delete: function(solicitud) {
      solicitud.destroyRecord();
    }
  }
});

