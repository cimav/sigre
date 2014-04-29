App.ProyectosRoute = Ember.Route.extend({

  model: function () {
    var obj = this.store.find('proyecto').orderBy;
    return this.store.filter(App.Proyecto, function (proyecto) {
      return !proyecto.get('isNew');
    });
  }

});