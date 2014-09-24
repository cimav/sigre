App.ProyectosNewController = Ember.ObjectController.extend({
  needs: ["application", 'proyectos'],
  isNotDirty: Ember.computed.not('content.isDirty'),

  // NOTE: al cargarse un select, si su valor es nulo y tiene elementos, selecciona
  // en automático el 1er valor lo que provoca al isDirty. El 1er valor puede ser el prompt.

  departamentoChanged: function() {
    if($.inArray(this.get('responsable'), this.get('departamento.empleados'), 1) < 0) {
      // si el responsable no pertenece a ese departamento lo deselecciona
      this.set('responsable', null);
      $("#selResponsables").select2("data", null);
      $('#selResponsables').select2();
    }

  }.observes('departamento'),

  tipoChanged: function() {
    if($.inArray(this.get('recurso'), this.get('tipo.sortedRecursos'), 1) < 0) {
      // si el recurso no pertenece a ese tipo lo deselecciona
      this.set('recurso', null);
      $("#selRecursos").select2("data", null);
      $('#selRecursos').select2();
    }

  }.observes('tipo'),

  recursoChanged: function() {
    if($.inArray(this.get('fondo'), this.get('recurso.sortedFondos'), 1) < 0) {
      // si el fondo no pertenece a ese recurso lo deselecciona
      this.set('fondo', null);
      $("#selFondos").select2("data", null);
      $('#selFondos').select2();
    }

  }.observes('recurso'),


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
