App.ContactosNetmultixController = Ember.ArrayController.extend({
  sortByClave: ['cl01_clave:asc'],
  sortedContactos: Ember.computed.sort('model', 'sortByClave'),
});
