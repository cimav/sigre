App.ProyectosRoute = Ember.Route.extend({
  model: function () {
    var pb = this.store.find('proyectoBusqueda');
    return pb;
  },

  actions: {
    reloadModel: function () {
      var controller = this.controller;
      this.store.find('proyectoBusqueda').then(function (proyectos) {
        controller.set('content', proyectos);
      });
    }
  },

//  renderTemplate: function () {
//    // FIXME: Corregir bug de back
//    this.render({ into: 'application' });
//  }

});

