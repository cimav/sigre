App.CostosVariablesRoute = Ember.Route.extend({

  model: function () {
    var obj = this.store.find('costo_variable');
  }

});