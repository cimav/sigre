App.CedulaController = Ember.ObjectController.extend({
  needs: ["application"], 

  Status: {
    inicial: 1,
    transmitiendo: 2,
    transmitida: 3,
    falla: 4,
    cancelada: 99
  },

  actions: {
    update: function (cedula) {
      var self = this;
      var onSuccess = function (cedula) {
        self.get('controllers.application').notify('Se actualizó cédula');
        self.transitionToRoute('cedula');
      };
      var onFail = function (cedula) {
        self.get('controllers.application').notify('Error al actualizar cédula', 'alert-danger');
      };

      cedula.save().then(onSuccess, onFail);
    },

    transmitir: function (cedula) {
        var self = this;
        var onSuccess = function (cedula) {
            self.transitionToRoute('cedula');
            self.get('controllers.application').notify('Cédula transmitiendose');
        };
        var onFail = function (cedula) {
            self.get('controllers.application').notify('Error al transmitir cédula', 'alert-danger');
        };
        cedula.set('status', this.get('Status.transmitiendo'));
        cedula.save().then(onSuccess, onFail);
    },

      buscar_subproyecto: function (cedula) {
          // buscar subproyecto en netmultix
          var self = this;
          var codigo = self.get('solicitud.codigo').replace('/','');
          var url = "/vinculacion/cedulas/" + self.get('id') + '/subproyecto/' + codigo; // url del controlador en rails

          var onSuccess = function (response) {
              self.get('controllers.application').notify('Se asignó subproyecto');
              self.set('sub_proyecto', response);
              self.transitionToRoute('cedula');
          };
          var onFail = function (response) {
              console.log('ERROR');
              console.log(response);
              self.get('controllers.application').notify('Error al buscar subproyecto en NetMultix', 'alert-danger');
          };

          $.get(url).then(onSuccess, onFail);
      }

  },

  isNotReadyForSave: function () {
      var result = this.get('content.isDirty') == true && this.get('content.isValid') == true;
      return !result;
  }.property('content.isDirty', 'content.isValid'),
  isNotReadyForTransmitir: function () {
     var result = this.get('content.isDirty') == true; // || this.get('content.isValid') == true;
     return result;
  }.property('content.isDirty', 'content.isValid'),

    isInicial: function() {
        return this.get('model.status') == this.get('Status.inicial');
    }.property('model.status'),
    isFalla: function() {
        return this.get('model.status') == this.get('Status.falla');
    }.property('model.status'),
    isInicialOrFalla: function() {
        return this.get('model.status') == this.get('Status.inicial') || this.get('model.status') == this.get('Status.falla');
    }.property('model.status'),
  isTransmitiendo: function() {
    return this.get('model.status') == this.get('Status.transmitiendo');
  }.property('model.status'),
  isTransmitida: function() {
    return this.get('model.status') == this.get('Status.transmitida');
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