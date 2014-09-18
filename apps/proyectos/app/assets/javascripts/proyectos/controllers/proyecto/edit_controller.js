App.ProyectoEditController = Ember.ObjectController.extend({
  needs: ['application', 'proyectos'],
  isNotDirty: Ember.computed.not('content.isDirty'),

  departamentoChanged: function() {
//    var hasChanged = this.get('_data.departamento.id') != this.get('departamento.id');
////    if (hasChanged) {
////      this.set('responsable', null);
////      //$("#selResponsables").select2("data", null);
////      $("#selResponsables").select2("val", "xxx");
////      $('#selResponsables').select2();
////    }
//    console.log("Here1>> " + hasChanged + "     :: " + this.get('responsable'));
//    var newResponsable = this.get('departamento.empleados.firstObject');
//    if (hasChanged && newResponsable != null) {
//      this.set('responsable', newResponsable);
//      $("#selResponsables").select2("data", newResponsable);
//    }
//
//    if (!hasChanged) {
//      this.set('responsable', null);
//      $("#selResponsables").select2("data", null);
//    }
//    $('#selResponsables').select2();
//    console.log("Here2>> " + this.get('responsable'));
//

    if($.inArray(this.get('responsable'), this.get('departamento.empleados'), 1) < 0) {
      // si el responsable no pertenece a ese departamento lo deselecciona
      this.set('responsable', null);
      $("#selResponsables").select2("data", null);
      $('#selResponsables').select2();
    }

  }.observes('departamento'),

  tipoChanged: function() {
//    var hasChanged = this.get('_data.tipo.id') != this.get('tipo.id');
//    if (hasChanged) {
////    var firstRecurso = this.get('tipo.sortedRecursos.firstObject');
//      this.set('recurso', null);
////    $('#selRecursos').select2();
//      $("#selRecursos").select2("data", null);
//      $('#selRecursos').select2();
//    }

    if($.inArray(this.get('recurso'), this.get('tipo.sortedRecursos'), 1) < 0) {
      // si el recurso no pertenece a ese tipo lo deselecciona
      this.set('recurso', null);
      $("#selRecursos").select2("data", null);
      $('#selRecursos').select2();
    }

  }.observes('tipo'),
//
  recursoChanged: function() {
//    var hasChanged = this.get('_data.recurso.id') != this.get('recurso.id');
//    if (hasChanged) {
//  //    var firstFondo = this.get('recurso.sortedFondos.firstObject');
//      this.set('fondo', null);
//  //    $('#selFondos').select2(); // regenera el select
//      $("#selFondos").select2("data", null);
//      $('#selFondos').select2();
//    }

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
        self.get('controllers.application').notify('Se actualizó proyecto');
      };

      var onFail = function(proyecto) {
        self.get('controllers.application').notify('Error al actualizar proyecto', 'alert-danger');
      };
      proyecto.save().then(onSuccess, onFail);
    }
  },

  belongsToChanged: function() {
    // detecta si hubo cambio en almenos una de las belongsTo
    var chk_belongs = this.get('sede.id') + "," + this.get('departamento.id') + "," + this.get('responsable.id')
        + ',' + this.get('tipo.id') + "," + this.get('recurso.id') + "," + this.get('fondo.id');
    chk_belongs = chk_belongs.replace('null','');
    this.set('values_belongs_to', chk_belongs);
  }.observes('sede', 'departamento', 'responsable', 'tipo', 'recurso', 'fondo')

});
