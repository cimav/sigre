App.ClienteRoute = Ember.Route.extend({
  setupController: function (controller, model) {
    controller.set('content', model);
  },
  afterModel: function () {
    // cada vez que se cambia de Cliente, redireccionarse/cargar la ruta Contactos
    this.transitionTo('contactos.index');
    //TODO no funciona con el click sobre simismo.
  }

});