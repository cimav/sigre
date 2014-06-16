App.MuestraController = Ember.ObjectController.extend({
  needs: ["application", "muestras", "muestra","solicitud"],
  isNotDirty: Ember.computed.not('content.isDirty'),
  Status: {
    inicial:    1,
    en_uso:     2,
  },
  div_id: function() {
    return 'muestra_' + this.get('id');
  }.property('id'),
  canEdit: function(){
    var solicitud = this.get('controllers.solicitud');
    return this.get('model.status') == this.get('Status.inicial') && solicitud.get('model.status')!=solicitud.get('model.Status.cancelada');
  }.property('model.status'),
  actions: {
    editMuestra: function(muestra) {
      muestrasController = this.get('controllers.muestras');
      muestra_id = muestra.get('id');
      if ((muestrasController.get('prev_muestra.id') != muestra_id) &&  (!muestrasController.closeEdit())) { return false; }
      if (!muestrasController.closeNewMuestra()) { return false; }
      muestrasController.set('prev_muestra', muestra);
      

      $('#muestra_' + muestra_id + ' .close').show();
      $('#muestra_' + muestra_id + ' .muestra-info').fadeOut(100);
      $('#muestra_' + muestra_id).animate({width: "450px"}, 200, function() {
        $('#muestra_' + muestra_id).addClass('muestra-editing');
        $('#muestra_' + muestra_id + ' .muestra-edit-form').fadeIn(100);
      });
    },
    updateMuestra: function(muestra) {
      var self = this
      var appController = this.get('controllers.application');
      var onSuccess = function(muestra) {
        appController.notify('Muestra actualizada');
        $('#muestra_' + muestra.get('id') + ' .close').hide();
        $('#muestra_' + muestra.get('id') + ' .muestra-edit-form').fadeOut(100);
        $('#muestra_' + muestra.get('id')).animate({width: "200px"}, 200, function() {
          $('#muestra_' + muestra_id).removeClass('muestra-editing');
          $('#muestra_' + muestra.get('id') + ' .muestra-info').fadeIn(100);
        });
      };

      var onFail = function(muestra) {
        appController.notify('Error al actualizar muestra', 'alert-danger');
      };
      muestra.save().then(onSuccess, onFail);
    },
    closeEdit: function() {
      this.get('controllers.muestras').closeEdit();
    },
    deleteMuestra: function(muestra) {
      var appController = this.get('controllers.application');
      if (confirm("¿Desea eliminar la muestra " + muestra.get('codigo') + "?")) {
        var onSuccess = function (muestra) {
          appController.notify('Se eliminó muestra');
        };
        var onFail = function (muestra) {
          appController.notify('Error al eliminar muestra', 'alert-danger');
        };
        $('#muestra_' + muestra.get('id')).fadeOut(200, function() {
          muestra.deleteRecord();
          muestra.save().then(onSuccess, onFail);
        });
      }
    }
  }
});
