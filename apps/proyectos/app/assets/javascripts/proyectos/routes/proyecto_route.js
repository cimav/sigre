App.ProyectoIndexRoute = Ember.Route.extend({
  model: function(){
    this.controllerFor('proyecto');
  },

  activate: function () {
    this.controllerFor('proyectos').set('showProyectosList', false);
  },

  deactivate: function () {
    this.controllerFor('proyectos').set('showProyectosList', true);
  },

  beforeModel: function() {
    if (this.modelFor('proyecto')  !== undefined && this.modelFor('proyecto').get('isDirty')) {
      //deshace los cambios no guardados del proyecto anterior
      this.modelFor('proyecto').rollback();
    }
  }
});

