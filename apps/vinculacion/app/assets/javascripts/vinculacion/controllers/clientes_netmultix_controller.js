App.ClientesNetmultixController = Ember.ArrayController.extend({
  sortByClave: ['cl01_clave:asc'],
  sortedClientes: Ember.computed.sort('model', 'sortByClave')
});
