App.AlertaController = Ember.ObjectController.extend({
  needs: ["application", "alertas", "solicitud", "alerta"],

  init: function () {
    this._super();
    this.set('newNota', self.store.createRecord('registro_nota'));
  },

  actions: {
  	addNota: function() {
      var nota = this.get('newNota');
      var self = this;
      var validation_errors = [];
      var error_msg = '';
      var onSuccess = function(nota) {
        self.get('controllers.application').notify('Se agrego nueva nota');
        self.set('newNota', self.store.createRecord('registro_nota'));
        var solicitud = self.get('controllers.solicitud');
        solicitud.get('model').reload();
      };

      var onFail = function(nota) {
        alert(nota);
        self.get('controllers.application').notify('Error al agregar nota', 'alert-danger');
      };
      
      if (validation_errors.length == 0) {
        self.get('model').get('registro_notas').pushObject(nota);
        nota.save().then(onSuccess, onFail);  
      } else {
        error_msg = "Existen errores:\n"
        validation_errors.forEach(function(e) {
          error_msg += e + "\n";
        });
        alert(error_msg);
      }
    }

  }
});
