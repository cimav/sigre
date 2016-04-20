App.AlertasController = Ember.ArrayController.extend({
  needs: ["application", "solicitud", "alerta"],
  actions: {
    // addNota: function() {
    //   var nota = this.get('newNota');
    //   var self = this;
    //   var validation_errors = [];
    //   var error_msg = '';
    //   var onSuccess = function(nota) {
    //     self.get('controllers.application').notify('Se agrego nueva nota');
    //     self.set('newNota', self.store.createRecord('registro_nota'));
    //     alert('chido');
    //     // self.closenewNota(true);

    //     // self.get('controllers.notas').send('reloadModel');

    //   };

    //   var onFail = function(nota) {
    //     alert('gacho');
    //     self.get('controllers.application').notify('Error al agregar nota', 'alert-danger');
    //   };
      
    //   if (validation_errors.length == 0) {
    //     // muestra.set('status', self.get('controllers.solicitud').get('Status.inicial'));
    //     //self.get('controllers.solicitud').get('model').get('muestras').pushObject(nota);
    //     alert('cool');
    //     nota.save().then(onSuccess, onFail);  
    //   } else {
    //     error_msg = "Existen errores:\n"
    //     validation_errors.forEach(function(e) {
    //       error_msg += e + "\n";
    //     });
    //     alert(error_msg);
    //   }
      
    // }
  }
});
