App.ProyectoController = Ember.ObjectController.extend({
  needs: ['application', 'proyectos'],

  isNotReadyForSave: function () {
    var result = this.get('content.isDirty') == true && this.get('content.isValid') == true;
    return !result;
  }.property('content.isDirty', 'content.isValid'),

  hasSolicitudes: function() {
    return this.get('model.solicitudes.length') > 0;
  }.property('solicitudes'),

  actions: {

    update: function () {
      self = this;
      var onSuccess = function (proyecto) {
        self.get('controllers.application').notify('Se actualizó proyecto ');
        self.transitionToRoute('proyecto', proyecto);
      };
      var onFail = function (proyecto) {
        self.get('controllers.application').notify('Error al agregar proyecto', 'alert-error');
      };

      var proyecto = self.get('model');
      if (proyecto.get('isValid')) {
        proyecto.save().then(onSuccess, onFail);
      }

    },

    destroy: function () {
      self = this;
      var codigo = self.get('model.rfc');
      if (window.confirm("?Eliminar proyecto: " + codigo + "?")) {
        var onSuccess = function (proyecto) {
          self.get('controllers.application').notify('Se eliminó proyecto ' + codigo);
          self.transitionToRoute('proyectos');
        };
        var onFail = function (proyecto) {
          self.get('controllers.application').notify('Error al eliminar proyecto', 'alert-error');
        };
        self.get('model').destroyRecord().then(onSuccess, onFail);
      }
    }

  }
});