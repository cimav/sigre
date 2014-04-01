App.MuestrasController = Ember.ArrayController.extend({
  needs: ["application", "solicitud"],
  itemController: 'muestra',
  prev_muestra: null,
  closeEdit: function() {
    if ($('#nueva-muestra').hasClass('new-muestra-open')) return true; 
    var muestra = this.get('prev_muestra');
    if (!muestra) return true;

    if (muestra.get('isDirty') && !confirm("¿Desea descartar los cambios en la muestra " + muestra.get('codigo') + "?")) {
      return false;
    } else {
      muestra.rollback();
    }
    el = $('#' + muestra.get('div_id'));
    el.find('.muestra-edit-form').fadeOut(100);
    el.animate({width: "200px"}, 200, function() {
      el.find('.muestra-info').fadeIn(100);
    });

    return true;
  },
  closeNewMuestra: function() {
    
    if (!$('#nueva-muestra').hasClass('new-muestra-open')) {
      return true;
    }

    if (!confirm("¿Desea abandonar la creación de una nueva muestra?")) {
      return false;
    } 
    
    this.set('newMuestra', self.store.createRecord('muestra'));
    $('#nueva-muestra form').fadeOut(100);
      $('#nueva-muestra').animate({width: "200px"}, 200, function() {
      $('#nueva-muestra #nueva-muestra-link').fadeIn(100);
      $('#nueva-muestra').removeClass('new-muestra-open');
    });
    return true;
  
  },
  actions: {
    addMuestra: function() {
      var muestra = this.get('newMuestra');
      var self = this
      var onSuccess = function(muestra) {
        self.get('controllers.application').notify('Se agrego nueva muestra');
        self.set('newMuestra', self.store.createRecord('muestra'));
        self.closeNewMuestra();
      };

      var onFail = function(muestra) {
        self.get('controllers.application').notify('Error al agregar muestra', 'alert-danger');
      };
      self.get('controllers.solicitud').get('model').get('muestras').pushObject(muestra);
      muestra.save().then(onSuccess, onFail);
    },
    showAddMuestraForm: function() {
      if(!this.closeEdit()) { return false; }
      $('#nueva-muestra').addClass('new-muestra-open');
      $('#nueva-muestra #nueva-muestra-link').fadeOut(100);
      $('#nueva-muestra').animate({width: "450px"}, 200, function() {
        $('#nueva-muestra form').fadeIn(100);
      });
    }
  }
});
