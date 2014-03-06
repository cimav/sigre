App.DepartamentosRoute = Ember.Route.extend({
  model: function() {
    this.store.find('departamento');
    return this.store.filter(App.Departamento, function(departamento) {
      return !departamento.get('isNew');
    })
  },
  actions: {
    delete: function(departamento) {
      departamento.destroyRecord();
    }
  }
});