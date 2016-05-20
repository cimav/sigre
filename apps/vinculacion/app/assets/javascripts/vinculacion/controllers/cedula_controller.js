App.CedulaController = Ember.ObjectController.extend({
  needs: ['application'],
  Status: {
    inicial: 1,
    transmitiendo: 2,
    transmitida: 3,
    cancelada: 99
  },

  actions: {
    update: function (cedula) {
      self = this;
      var onSuccess = function (cedula) {
        self.transitionToRoute('cedula');
        self.get('controllers.application').notify('Se actualizó cédula');
      };
      var onFail = function (cedula) {
        self.get('controllers.application').notify('Error al actualizar cédula', 'alert-danger');
      };

      cedula.save().then(onSuccess, onFail);
    },

    transmitir: function (cedula) {
      self.get('controllers.application').notify('Cédula transmitida');
    }
  },

  isInicial: function() {
    return this.get('model.status') == this.get('Status.inicial');
  }.property('model.status'),
  isTransmitiendo: function() {
    return this.get('model.status') == this.get('Status.transmitiendo');
  }.property('model.status'),
  isTransmitida: function() {
    return this.get('model.status') == this.get('Status.transmitida');
  }.property('model.status'),

  isNotReadyForSave: function() {
    return false;
  }.property('model.status'),

  total_porcentaje: function() {
    var remanentes = this.get('model.remanentes');
    var result = 0.00;
    remanentes.forEach(function (rem) {
      result = result + rem.get('porcentaje_participacion');
    });
    return result;
  }.property('model.porcentaje_participacion'),

  chk_total_porcentaje: function() {
    var result = this.get('total_porcentaje') == 100;
    return result;
  }.property('total_porcentaje'),

  has_costos_class: function() {
    var result = "";
    if (this.get('model.costos_variables.length') == 0) {
      result = "div-costos-variables-remanente-opacity";
    }
    return result;
  }.property('model.costos_variables')

});