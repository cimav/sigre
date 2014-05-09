App.ClienteController = Ember.ObjectController.extend({
  needs: ['application', 'clientes', 'cliente', 'contacto'],

  contactosCount: Ember.computed.alias('content.contactos.length'),

  isNotReadyForSave: function () {
    var result = this.get('content.isDirty') == true && this.get('content.isValid') == true;
    return !result;
  }.property('content.isDirty', 'content.isValid'),

  actions: {

    update: function () {
      self = this
      var onSuccess = function (cliente) {

        //self.get('controllers.application').notify('Se actualizó cliente ');// + self.get('model.rfc'));

        self.get('target').reset(); // forza a re-cargar el modelo de cliente y en consecuencia, a el afterModel de la route.
        // FIXME: reset no funciona provoca error en el self.get('controllers.application').notify

        self.transitionToRoute('cliente', cliente);
      };
      var onFail = function (cliente) {
        self.get('controllers.application').notify('Error al agregar cliente', 'alert-error');
      };

      var cliente = self.get('model');
      if (cliente.get('isValid')) {
        cliente.save().then(onSuccess, onFail);
      }

    },

    destroy: function () {
      self = this;
      var rfc = self.get('model.rfc');
      if (window.confirm("?Eliminar Cliente: " + rfc + "?")) {
        var onSuccess = function (cliente) {
          self.get('controllers.application').notify('Se eliminó cliente ' + rfc);
          self.transitionToRoute('clientes');
        };
        var onFail = function (cliente) {
          self.get('controllers.application').notify('Error al eliminar cliente', 'alert-error');
        };

        self.get('model').destroyRecord().then(onSuccess, onFail);

      }
    }

  }
});