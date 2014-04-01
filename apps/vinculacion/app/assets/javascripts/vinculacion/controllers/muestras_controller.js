App.MuestrasController = Ember.ArrayController.extend({
  needs: ["application", "solicitud"],
  itemController: 'muestra',

  closeNewMuestra: function() {
    $('#nueva-muestra form').fadeOut(100);
      $('#nueva-muestra').animate({width: "200px"}, 200, function() {
      $('#nueva-muestra #nueva-muestra-link').fadeIn(100);
    });
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
