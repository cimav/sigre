App.ContactosNewRoute = Ember.Route.extend({
  model: function () {
    return this.store.createRecord('contacto');
  },
  activate: function () {
    this.controllerFor('contactos').set('showContactos', false);
  },
  deactivate: function () {
    this.controllerFor('contactos').set('showContactos', true);
    this.transitionTo('contactos');
  }

});

