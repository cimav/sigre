App.RemanentesRoute = Ember.Route.extend({

  model: function () {
    this.modelFor('cedula').get('remanentes');
  }

});