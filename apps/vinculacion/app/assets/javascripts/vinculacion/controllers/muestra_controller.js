App.MuestraController = Ember.ObjectController.extend({
  needs: ["application", "cotizaciones", "muestras", "muestra","solicitud"],
  isNotDirty: Ember.computed.not('content.isDirty'),

  sortProperties: ['consecutivo:asc'],
  sortedDetalles: Ember.computed.sort('model.muestras_detalle', 'sortProperties'),

  Status: {
    inicial:    1,
    en_uso:     2
  },
  
  div_id: function() {
    return 'muestra_' + this.get('id');
  }.property('id'),
  
  canEdit: function(){
    var solicitud = this.get('controllers.solicitud');
    // se puede editar la muestra mientras la solicitud no llegue a proceso, ni finalizada y ni cancelada
    return solicitud.get('model.status') < solicitud.get('model.Status.en_proceso');
  }.property('model.status'),

  hasNotDirtyDetalles: function() {
    return this.get('model.muestras_detalle').filterBy('isDirty', true).get('length') === 0;
  }.property('model.muestras_detalle.@each.isDirty'),


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
      var self = this;
      var appController = this.get('controllers.application');
      var onSuccess = function(muestra) {
        appController.notify('Muestra actualizada');
        $('#muestra_' + muestra.get('id') + ' .close').hide();
        $('#muestra_' + muestra.get('id') + ' .muestra-edit-form').fadeOut(100);
        $('#muestra_' + muestra.get('id')).animate({width: "200px"}, 200, function() {
          $('#muestra_' + muestra_id).removeClass('muestra-editing');
          $('#muestra_' + muestra.get('id') + ' .muestra-info').fadeIn(100);
        });

        self.get('controllers.muestras').send('reloadModel');
        self.get('controllers.cotizaciones').send('reloadModel');
      };

      var onFail = function(muestra) {
        appController.notify('Error al actualizar muestra', 'alert-danger');
      };
      muestra.save().then(onSuccess, onFail);
    },
    closeEdit: function() {
      this.get('controllers.muestras').closeEdit();

      this.get('model.muestras_detalle').filterBy('isDirty',true).forEach(function(detalle){
        detalle.rollback();
      });

      $('#muestra_' + muestra_id + ' .muestra-edit-detalle-form').fadeOut(100);
    },
    deleteMuestra: function(muestra) {
      var self = this;
      var appController = this.get('controllers.application');
      if (confirm("¿Desea eliminar la(s) muestra(s) " + muestra.get('rango') + "?")) { // + muestra.get('codigo') + "?")) {
        var onSuccess = function (muestra) {
          appController.notify('Se eliminó muestra');

          self.get('controllers.muestras').send('reloadModel');
          self.get('controllers.cotizaciones').send('reloadModel');
        };
        var onFail = function (muestra) {
          appController.notify('Error al eliminar muestra', 'alert-danger');
        };
        $('#muestra_' + muestra.get('id')).fadeOut(200, function() {
          muestra.deleteRecord();
          muestra.save().then(onSuccess, onFail);
        });
      }
    },
    editMuestraDetalle: function(muestra) {
      muestrasController = this.get('controllers.muestras');
      muestra_id = muestra.get('id');
      if ((muestrasController.get('prev_muestra.id') != muestra_id) &&  (!muestrasController.closeEdit())) { return false; }
      if (!muestrasController.closeNewMuestra()) { return false; }
      muestrasController.set('prev_muestra', muestra);

      $('#muestra_' + muestra_id + ' .close').show();
      $('#muestra_' + muestra_id + ' .muestra-info').fadeOut(100);
      $('#muestra_' + muestra_id).animate({width: "450px"}, 200, function() {
        $('#muestra_' + muestra_id).addClass('muestra-editing');
        $('#muestra_' + muestra_id + ' .muestra-edit-detalle-form').fadeIn(100);

      });
    },
    updateMuestraDetalle: function(muestra) {
      var appController = this.get('controllers.application');

      muestra.get('muestras_detalle').filterBy('isDirty', true).forEach(function(det){
        det.save();
      });

      appController.notify('Detalles de la muestra actualizados');
      $('#muestra_' + muestra.get('id') + ' .close').hide();
      $('#muestra_' + muestra.get('id') + ' .muestra-edit-detalle-form').fadeOut(100);
      $('#muestra_' + muestra.get('id')).animate({width: "200px"}, 200, function() {
        $('#muestra_' + muestra.get('id')).removeClass('muestra-editing');
        $('#muestra_' + muestra.get('id') + ' .muestra-info').fadeIn(100);
      });

    }

  }
});
