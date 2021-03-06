App.MuestrasController = Ember.ArrayController.extend({
  needs: ["application", "solicitud", "muestra", "muestras"],
  itemController: 'muestra',
  prev_muestra: null,
  //allowAddMuestras: Ember.computed.alias('controllers.solicitud.allowAddServicios'),

  allowAddMuestras: function() {
    var result = this.get('controllers.solicitud.allowAddServicios');// && !this.get('controllers.solicitud.isTipoI');
    if (this.get('controllers.solicitud.isTipoI')) {
      // si es Tipo 1, permite agregar una sola muestra
      result = result && (this.get('length') <= 0);
    }
    return result;
  }.property('length'),

  closeEdit: function() {
    if ($('#nueva-muestra').hasClass('new-muestra-open')) return true; 
    var muestra = this.get('prev_muestra');
    if (!muestra) return true;

    if (muestra.get('isDirty') && !confirm("¿Desea descartar los cambios en la(s) muestra(s) " + muestra.get('rango') + "?")) {
      return false;
    } else {
      muestra.rollback();
    }
    el = $('#muestra_' + muestra.get('id'));
    $('#muestra_' + muestra.get('id') + ' .close').hide();
    el.find('.muestra-edit-form').fadeOut(100);
    el.find('.muestra-edit-detalle-form').fadeOut(100);
    el.animate({width: "220px"}, 200, function() {
      el.find('.muestra-info').fadeIn(100);
    });

    return true;
  },
  closeNewMuestra: function(fromSaveNew) {
    
    if (!$('#nueva-muestra').hasClass('new-muestra-open')) {
      return true;
    }
    
    if (!fromSaveNew && !confirm("¿Desea abandonar la creación de una nueva muestra?")) {
      return false;
    } 
    
    this.set('newMuestra', self.store.createRecord('muestra'));

    $('#nueva-muestra .close').hide();
    $('#nueva-muestra form').fadeOut(100);
      $('#nueva-muestra').animate({width: "220px"}, 200, function() {
      $('#nueva-muestra #nueva-muestra-link').fadeIn(100);
      $('#nueva-muestra').removeClass('new-muestra-open');
    });
    return true;
  
  },
  actions: {
    addMuestra: function() {
      var muestra = this.get('newMuestra');
      var self = this;
      var validation_errors = [];
      var error_msg = '';
      var onSuccess = function(muestra) {
        self.get('controllers.application').notify('Se agrego nueva muestra');
        self.set('newMuestra', self.store.createRecord('muestra'));
        self.closeNewMuestra(true);

        self.get('controllers.muestras').send('reloadModel');

      };

      var onFail = function(muestra) {
        self.get('controllers.application').notify('Error al agregar muestra', 'alert-danger');
      };
      
      if ((muestra.get('identificacion') === undefined) || (muestra.get('identificacion').trim() == '')) {
        validation_errors.push('Se debe especificar la identificación de la muestra');
      }

      if ((muestra.get('cantidad') === undefined) || (muestra.get('cantidad') <= 0)) {
        validation_errors.push('Se debe especificar una cantidad mayor que 0');
      }

      if (validation_errors.length == 0) {
        muestra.set('status', self.get('controllers.solicitud').get('Status.inicial'));
        self.get('controllers.solicitud').get('model').get('muestras').pushObject(muestra);
        muestra.save().then(onSuccess, onFail);  
      } else {
        error_msg = "Existen errores:\n"
        validation_errors.forEach(function(e) {
          error_msg += e + "\n";
        });
        alert(error_msg);
      }
      
    },
    showAddMuestraForm: function() {
      if(!this.closeEdit()) { return false; }
      $('#nueva-muestra .close').show();
      $('#nueva-muestra').addClass('new-muestra-open');
      $('#nueva-muestra #nueva-muestra-link').fadeOut(100);
      $('#nueva-muestra').animate({width: "450px"}, 200, function() {
        $('#nueva-muestra form').fadeIn(100);
      });
    },
    closeNewMuestra: function() {
      this.closeNewMuestra();
    }
  }
});
