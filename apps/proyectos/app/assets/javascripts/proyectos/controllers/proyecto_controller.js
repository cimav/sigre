App.ProyectoController = Ember.ObjectController.extend ({
  showProyectoTemplate: true,

  isProyectoBase: function() {
    var result =  this.get('model.proyecto_base') == null;
    return result;
  }.property('model.proyecto_base')


});
