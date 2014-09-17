App.ProyectoIndexRoute = Ember.Route.extend({
  model: function(){
    this.controllerFor('proyecto');
  },

  activate: function () {
    this.controllerFor('proyectos').set('showProyectosList', false);
  },

  deactivate: function () {
    this.controllerFor('proyectos').set('showProyectosList', true);
  }

});

