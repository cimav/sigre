App.ProyectoRoute = Ember.Route.extend({

  poll: null,

  activate: function () {
    this.controllerFor('proyectos').set('showProyectosList', false);
    console.log('Poll Proyecto');
    this.reloadProyecto();
  },

  deactivate: function () {
    this.controllerFor('proyectos').set('showProyectosList', true);
    Ember.run.cancel(this.poll);
  },

  reloadProyecto: function () {
    var self = this;
    this.poll = Ember.run.later(function () {
      console.log('Reload...');
      self.get('controller.model').reload();
      self.reloadProyecto();
    }, 10000);
  }

});
