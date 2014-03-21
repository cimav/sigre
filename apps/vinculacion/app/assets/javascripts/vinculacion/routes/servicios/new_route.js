App.ServiciosNewRoute = Ember.Route.extend({
  activate: function() {
    this.controllerFor('servicios').set('showServiciosList', false);
  },
  deactivate: function() {
    this.controllerFor('servicios').set('showServiciosList', true);
  },
  model: function() {
    return this.store.createRecord('servicio');
  },
  setupController: function(controller, model) {
    controller.set('content', model);
  },
  /*
  actions: {
    submit: function() {
      servicio = this.get('model');
      console.log(servicio);
      self = this
      var onSuccess = function(servicio) {
        self.transitionTo('servicio', servicio);
        self.controllerFor('application').notify('Se agrego nuevo servicio');
      };

      var onFail = function(servicio) {
        self.controllerFor('application').notify('Error al agregar servicio', 'alert-danger');
      };

      servicio.save().then(onSuccess, onFail);

    }
  }*/
});