App.MuestrasController = Ember.ArrayController.extend({
  needs: ["application", "solicitud"],
  actions: {
    editMuestra: function(muestra_id) {
      $('#muestra_' + muestra_id + ' .muestra-info').fadeOut(100);
      $('#muestra_' + muestra_id).animate({width: "450px"}, 200, function() {
        $('#muestra_' + muestra_id + ' .muestra-edit-form').fadeIn(100);
      });
    },
    updateMuestra: function(muestra) {
      var self = this
      var onSuccess = function(muestra) {
        self.get('controllers.application').notify('Muestra actualizada');
        $('#muestra_' + muestra.get('id') + ' .muestra-edit-form').fadeOut(100);
        $('#muestra_' + muestra.get('id')).animate({width: "200px"}, 200, function() {
          $('#muestra_' + muestra.get('id') + ' .muestra-info').fadeIn(100);
        });
      };

      var onFail = function(muestra) {
        self.get('controllers.application').notify('Error al actualizar muestra', 'alert-danger');
      };
      muestra.save().then(onSuccess, onFail);
    },
    addMuestra: function() {
      var muestra = this.get('newMuestra');
      var self = this
      var onSuccess = function(muestra) {
        self.get('controllers.application').notify('Se agrego nueva muestra');
        self.set('newMuestra', self.store.createRecord('muestra'));
      };

      var onFail = function(muestra) {
        self.get('controllers.application').notify('Error al agregar muestra', 'alert-danger');
      };
      self.get('controllers.solicitud').get('model').get('muestras').pushObject(muestra);
      muestra.save().then(onSuccess, onFail);
    },
    deleteMuestra: function(muestra) {
      var self=this
      if (confirm("¿Desea eliminar la muestra " + muestra.get('identificacion') + "?")) {
        var onSuccess = function (muestra) {
          self.get('controllers.application').notify('Se eliminó muestra');
        };
        var onFail = function (muestra) {
          self.get('controllers.application').notify('Error al eliminar muestra', 'alert-danger');
        };
        $('#muestra_' + muestra.get('id')).fadeOut(200, function() {
          muestra.deleteRecord();
          muestra.save().then(onSuccess, onFail);
        });
      }
    }
  }
});
