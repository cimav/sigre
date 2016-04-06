App.ContactosNetmultixRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('cliente_netmultix').get('contactos_netmultix');
  }
});