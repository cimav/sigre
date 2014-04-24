App.ContactoEditRoute = Ember.Route.extend({
  model: function () {
    return this.modelFor('contacto');
  },
  activate: function () {
    this.controllerFor('contactos').set('showContactos', false);
  },
  deactivate: function () {
    this.controllerFor('contactos').set('showContactos', true);
    this.transitionTo('contactos');
  }

});
