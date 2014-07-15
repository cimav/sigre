App.CostosVariablesRoute = Ember.Route.extend({

  model: function () {
    this.modelFor('cedula').get('costos_variables');
  }

});