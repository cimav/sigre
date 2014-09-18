App.ProyectosRoute = Ember.Route.extend({
  model: function () {
    return this.store.find('proyectoBusqueda');
  },

  actions: {
    reloadModel: function () {
      // usada despues de agregar o actualizar un proyecto
      var controller = this.controller;
      this.store.find('proyectoBusqueda').then(function (proyectos) {
        controller.set('content', proyectos);
      });
    },

    willTransition: function(transition) {
      // si la transición es a proyectos, activa el showProyectosList
      var show = transition.targetName == "proyectos.index";
      this.controller.set('showProyectosList', show);
    }

  }


});

