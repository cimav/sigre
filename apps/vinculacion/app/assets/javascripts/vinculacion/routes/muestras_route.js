App.MuestrasRoute = Ember.Route.extend({
  model: function() {
    this.store.find('muestra');
    return this.store.filter(App.Muestra, function(muestra) {
      return !muestra.get('isNew');
    })
  },
  actions: {
    delete: function(muestra) {
      muestra.destroyRecord();
    }
  }
});