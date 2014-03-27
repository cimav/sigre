App.ContactosNewController = Ember.ObjectController.extend({
  needs: ["application", 'cliente'],

  isNotReadyForSave: function () {
    var result = this.get('content.isDirty') == true && this.get('content.isValid') == true;
    return !result;
  }.property('content.isDirty', 'content.isValid'),

  actions: {

    update: function (contacto) {
      this.get('controllers.application').notify('UPDATE ONCE');
    },

    create: function (contacto) {
      self = this;

      var onSuccess = function (contacto) {
        self.transitionToRoute('contactos.index');
        self.get('controllers.application').notify('Se agrego nuevo contacto');
      };
      var onFail = function (contacto) {
        self.get('controllers.application').notify('Error al agregar contacto', 'alert-danger');
      };
      if (contacto.get('isValid')) {
        self.get('controllers.cliente').get('contactos').pushObject(contacto);
        contacto.save().then(onSuccess, onFail);

      }
    }

  }

});

