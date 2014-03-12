App.SolicitudController = Ember.ObjectController.extend({
  needs: ["muestras", "application"],
  isNotDirty: Ember.computed.not('content.isDirty'),
  actions: {
    submit: function() {
      this.get('model').save();
      this.get('controllers.application').notify('Solicitud actualizada');
    }
  }
});