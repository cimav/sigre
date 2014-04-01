App.MuestraController = Ember.ObjectController.extend({
  needs: ["application", "solicitud"],
  isNotDirty: Ember.computed.not('content.isDirty'),
  actions: {
    editMuestra: function(muestra) {
      // if(!this.closeEdit()) { return false; }
      // this.closeNewMuestra();
      muestra_id = muestra.get('id');

      $('#muestra_' + muestra_id + ' .muestra-info').fadeOut(100);
      $('#muestra_' + muestra_id).animate({width: "450px"}, 200, function() {
        $('#muestra_' + muestra_id).addClass('muestra-editing');
        $('#muestra_' + muestra_id + ' .muestra-edit-form').fadeIn(100);
      });
    },
    updateMuestra: function(muestra) {
      var self = this
      var onSuccess = function(muestra) {
        self.get('controllers.application').notify('Muestra actualizada');
        $('#muestra_' + muestra.get('id') + ' .muestra-edit-form').fadeOut(100);
        $('#muestra_' + muestra.get('id')).animate({width: "200px"}, 200, function() {
          $('#muestra_' + muestra_id).removeClass('muestra-editing');
          $('#muestra_' + muestra.get('id') + ' .muestra-info').fadeIn(100);
        });
      };

      var onFail = function(muestra) {
        self.get('controllers.application').notify('Error al actualizar muestra', 'alert-danger');
      };
      muestra.save().then(onSuccess, onFail);
    },
    deleteMuestra: function(muestra) {
      var app = this.get('controllers.application');
      if (confirm("¿Desea eliminar la muestra " + muestra.get('codigo') + "?")) {
        var onSuccess = function (muestra) {
          app.notify('Se eliminó muestra');
        };
        var onFail = function (muestra) {
          app.notify('Error al eliminar muestra', 'alert-danger');
        };
        $('#muestra_' + muestra.get('id')).fadeOut(200, function() {
          muestra.deleteRecord();
          muestra.save().then(onSuccess, onFail);
        });
      }
    }
  }
});