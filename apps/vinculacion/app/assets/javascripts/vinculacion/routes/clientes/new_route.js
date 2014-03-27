App.ClientesNewRoute = Ember.Route.extend({
  model: function () {
    return this.store.createRecord('cliente');
  }

});