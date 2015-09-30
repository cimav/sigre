App.CatalogoRoute = Ember.Route.extend({

  model: function () {
    return this.store.find('servicio_bitacora');
  }

});
