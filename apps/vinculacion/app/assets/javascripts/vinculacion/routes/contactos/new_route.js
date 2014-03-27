App.ContactosNewRoute = Ember.Route.extend({
  model: function () {
    return this.store.createRecord('contacto');
  },
  deactivate: function () {
    this.transitionTo('contactos.index');
  }

});
