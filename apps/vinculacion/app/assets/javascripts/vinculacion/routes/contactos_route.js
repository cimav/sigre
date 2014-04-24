App.ContactosRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('cliente').get('contactos');
  }
});