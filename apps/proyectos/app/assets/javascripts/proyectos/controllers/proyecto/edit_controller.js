App.ProyectoEditController = Ember.ObjectController.extend({
  needs: ['application', 'proyectos'],
  isNotDirty: Ember.computed.not('content.isDirty'),

  // WIP
//  departamentoChanged: function() {
//
//    console.log("EmpSel1: " + this.get('responsable'));
//
//    var isChanged = this.get('_data.departamento.id') != this.get('departamento.id');
//    if (isChanged) {
//      this.set('convenio', 'cambvio');
//    //  this.set('responsable', this.get('departamento.empleados.content')[0]);
//    //  var nombre_completo = this.get('departamento.empleados.content')[0].get('nombre_completo');
////      $('#select2-chosen-3').text('') ; //nombre_completo);
//      //this.get('departamento.empleados').first();
////      this.set('responsable', null);
////      this.$().select2()[0].selectedIndex = 0;
////      this.$().select.$().trigger('change');
//    }
//    console.log("EmpSel2: " + this.get('responsable'));
//
//  }.observes('departamento'),
//
//  default: function() {
//    console.log("EmpSel3: " + this.get('responsable'));
//  }.observes('responsable'),

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
    var chk_belongs = this.get('sede.id') + "," + this.get('departamento.id');
    this.set('values_belongs_to', chk_belongs);
  }.observes('sede', 'departamento')

});
