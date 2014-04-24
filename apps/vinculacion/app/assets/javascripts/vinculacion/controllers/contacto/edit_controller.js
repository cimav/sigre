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
        self.get('controllers.application').notify('Se actualizó contacto');
        self.transitionToRoute('contactos');
      };
      var onFail = function (contacto) {
        self.get('controllers.application').notify('Error al actualizar contacto', 'alert-danger');
      };

      if (contacto.get('isValid')) {
        contacto.save().then(onSuccess, onFail);
      }
    }

  }

});