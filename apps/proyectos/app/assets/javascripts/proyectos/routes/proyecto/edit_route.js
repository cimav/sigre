App.ProyectoEditRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('proyecto');
  },

  activate: function () {
    this.controllerFor('proyectos').set('showProyectosList', false);
    this.controllerFor('proyecto').set('showProyectoTemplate', false);
  },

  deactivate: function () {
    this.controllerFor('proyectos').set('showProyectosList', true);
    this.controllerFor('proyecto').set('showProyectoTemplate', true);
  }

});
