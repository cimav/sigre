App.ProyectosNewController = Ember.ObjectController.extend({
  needs: ["application"],

  isNotReadyForSave: function () {
    var result = this.get('content.isDirty') == true && this.get('content.isValid') == true;
    return !result;
  }.property('content.isDirty', 'content.isValid'),

  actions: {
    create: function (proyecto) {
      self = this
      var onSuccess = function (proyecto) {
        self.transitionToRoute('proyecto', proyecto);
        self.get('controllers.application').notify('Se agrego nuevo proyecto');
      };

      var onFail = function (proyecto) {
        self.get('controllers.application').notify('Error al agregar proyecto', 'alert-error');
      };

      if (proyecto.get('isValid')) {

        proyecto.set('codigo', proyecto.get('codigo').toUpperCase());

        proyecto.save().then(onSuccess, onFail);
      }
    }
  }

});