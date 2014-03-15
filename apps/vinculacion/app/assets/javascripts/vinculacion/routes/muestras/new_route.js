App.MuestrasNewRoute = Ember.Route.extend({
  init: function() {
    console.log('NEW MUESTRA INIT ROUTE')
  },
  model: function() {
    console.log('MODEL NEW MUESTRA');
    return this.store.createRecord('muestra');
  }
});