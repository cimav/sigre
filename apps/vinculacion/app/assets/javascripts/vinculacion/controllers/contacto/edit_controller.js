App.ContactoEditController = Ember.ObjectController.extend({
  needs: ['application', 'contacto'],

  isNotReadyForSave: function () {
    var result = this.get('content.isDirty') == true && this.get('content.isValid') == true;
    return !result;
  }.property('content.isDirty', 'content.isValid'),

  actions: {

    update: function (contacto) {

      self = this;

      var onSuccess = function (contacto) {
        self.transitionToRoute('contactos');
        self.get('controllers.application').notify('Se actualizó contacto');
      };
      var onFail = function (contacto) {
        self.get('controllers.application').notify('Error al actualizar contacto', 'alert-danger');
      };

      if (contacto.get('isValid')) {
        contacto.save().then(onSuccess, onFail);
      }
    },

    destroy: function(contacto) {
      self = this;
      var appController = self.get('controllers.application');
      if (confirm("¿Desea eliminar el contacto " + contacto.get('nombre') + "?")) {
        var onSuccess = function (contacto) {
          appController.notify('Se eliminó contacto');
          self.transitionToRoute('contactos');
        };
        var onFail = function (muestra) {
          appController.notify('Error al eliminar contacto', 'alert-danger');
        };
        contacto.destroyRecord().then(onSuccess, onFail);
      }
    }


  }

});