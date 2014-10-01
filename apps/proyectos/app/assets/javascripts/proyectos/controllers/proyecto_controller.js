
App.ProyectoController = Ember.ObjectController.extend ({
  showProyectoTemplate: true,

  isProyectoBase: function() {
    var result =  this.get('model.proyecto_base') == null;
    return result;
  }.property('model.proyecto_base'),

//  init: function() {
//    self = this;
//    Promise.all([
//      this.store.find('proyecto')
//    ]).then(function(values){
//      //self.controllerFor('proyecto').set('proyectosBaseCache', values[0]);
//      self.set('proyectosBaseCache', values[0]);
//      return values;
//    });
//  }

});
