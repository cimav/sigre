App.ProyectosNewController = Ember.ObjectController.extend({
  needs: ["application", 'proyectos'],
  isNotDirty: Ember.computed.not('content.isDirty'),
  actions: {
    submit: function() {
      var proyecto = this.get('model');
      var self = this;
      var onSuccess = function(proyecto) {

        // recarga la lista de solicitud_busqueda
        self.get('controllers.proyectos').send('reloadModel');

        self.transitionToRoute('proyecto', proyecto);
        self.get('controllers.application').notify('Se agregó nuevo proyecto');
      };

      var onFail = function(proyecto) {
        self.get('controllers.application').notify('Error al agregar proyecto', 'alert-danger');
      };

      proyecto.save().then(onSuccess, onFail);
    }
  }
});
