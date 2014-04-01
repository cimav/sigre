App.SolicitudController = Ember.ObjectController.extend({
  needs: ["muestras", "application"],
  isNotDirty: Ember.computed.not('content.isDirty'),
  muestrasCount: Ember.computed.alias('content.muestras.length'),
  serviciosCount: Ember.computed.alias('content.servicios.length'),
  actions: {
    submit: function() {
      this.get('model').save();
      this.get('controllers.application').notify('Solicitud actualizada');
    }
  }
});