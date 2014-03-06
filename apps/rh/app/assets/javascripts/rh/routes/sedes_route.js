App.SedesRoute = Ember.Route.extend({
  model: function() {
    this.store.find('sede');
    return this.store.filter(App.Sede, function(sede) {
      return !sede.get('isNew');
    })
  },
  actions: {
    delete: function(sede) {
      sede.destroyRecord();
    }
  }
});