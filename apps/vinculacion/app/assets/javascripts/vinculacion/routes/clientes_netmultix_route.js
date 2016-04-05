App.ClientesNetmultixRoute = Ember.Route.extend({

  model: function() {
    return this.store.find('cliente_netmultix');
  }

});


