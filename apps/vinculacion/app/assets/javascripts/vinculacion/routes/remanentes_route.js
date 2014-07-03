App.RemanentesRoute = Ember.Route.extend({

  model: function () {
    var obj = this.store.find('remanente');
  }

});