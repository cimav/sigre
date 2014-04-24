App.ContactosNewController = Ember.ObjectController.extend({
  needs: ["application", 'cliente'],

  isNotReadyForSave: function () {
    var result = this.get('content.isDirty') == true && this.get('content.isValid') == true;
    return !result;
  }.property('content.isDirty', 'content.isValid'),

  actions: {

    create: function (contacto) {
      self = this;

      var onSuccess = function (contacto) {
        self.get('controllers.application').notify('Se agrego nuevo contacto');
        self.transitionToRoute('contactos');
      };
      var onFail = function (contacto) {
        self.get('controllers.application').notify('Error al agregar contacto', 'alert-danger');
      };
      if (contacto.get('isValid')) {
        var cliente = self.get('controllers.cliente');
        cliente.get('contactos').pushObject(contacto);
        contacto.save().then(onSuccess, onFail);
      }
    }

  }

});

