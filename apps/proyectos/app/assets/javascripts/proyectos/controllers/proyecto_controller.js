App.ProyectoController = Ember.ObjectController.extend ({
  needs: ['proyectos'],
  showProyectoTemplate: true,

  isProyectoBase: function() {
    var result =  this.get('model.proyecto_base') == null;
    return result;
  }.property('model.proyecto_base')

});
