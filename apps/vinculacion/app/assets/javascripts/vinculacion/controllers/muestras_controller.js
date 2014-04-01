App.MuestrasController = Ember.ArrayController.extend({
  needs: ["application", "solicitud"],
  itemController: 'muestra',

  closeNewMuestra: function() {
    $('#nueva-muestra form').fadeOut(100);
      $('#nueva-muestra').animate({width: "200px"}, 200, function() {
      $('#nueva-muestra #nueva-muestra-link').fadeIn(100);
    });
  },
  closeEdit: function() {
    var result = true;
    $('.muestra-editing').each(function() {
      el = $('#' + this.id);
      codigo = el.find('.muestra-codigo').first().data('codigo');
      if (el.hasClass('is-dirty') && (!confirm("¿Desea descartar los cambios en la muestra " + codigo + "?"))) {
        result = false;
        return false;
      }
      el.find('.muestra-edit-form').fadeOut(100);
      el.animate({width: "200px"}, 200, function() {
        el.find('.muestra-info').fadeIn(100);
        el.removeClass('muestra-editing');
      });
    }); 
    return result;
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
      $('#nueva-muestra #nueva-muestra-link').fadeOut(100);
      $('#nueva-muestra').animate({width: "450px"}, 200, function() {
        $('#nueva-muestra form').fadeIn(100);
      });
    }
  }
});
