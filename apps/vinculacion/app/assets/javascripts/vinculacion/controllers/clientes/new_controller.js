App.ClientesNewController = Ember.ObjectController.extend({
  needs: ["application"],

  // TODO Donde ponerlo para que NO se repita con clientes_controller
  isNotReadyForSave: function () {
    var result = this.get('content.isDirty') == true && this.get('content.isValid') == true;
    return !result;
  }.property('content.isDirty', 'content.isValid'),

  actions: {
    create: function (cliente) {
      self = this
      var onSuccess = function (cliente) {
        self.transitionToRoute('cliente', cliente);
        self.get('controllers.application').notify('Se agrego nuevo cliente');
      };

      var onFail = function (cliente) {
        self.get('controllers.application').notify('Error al agregar cliente', 'alert-error');
      };

      if (cliente.get('isValid')) {

        if (!Ember.isEmpty(cliente.get('rfc'))) {
          cliente.set('rfc', cliente.get('rfc').toUpperCase());
        }

        cliente.save().then(onSuccess, onFail);
      }
    }
  }

});
