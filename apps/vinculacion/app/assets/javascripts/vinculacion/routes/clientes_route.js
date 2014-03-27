App.ClientesRoute = Ember.Route.extend({

  model: function () {
    var obj = this.store.find('cliente');
    return this.store.filter(App.Cliente, function (cliente) {
      return !cliente.get('isNew');
    });
  }

});