App.SolicitudController = Ember.ObjectController.extend({
  needs: ["muestras", "application"],
  isNotDirty: Ember.computed.not('content.isDirty'),
  muestrasCount: Ember.computed.alias('content.muestras.length'),
  serviciosCount: Ember.computed.alias('content.servicios.length'),
  prioridad_obj: function() {
    self = this
    return $.grep(this.get('controllers.application.prioridades'), function (p) {
      return p.id == self.get('prioridad');
    })[0];
  }.property('prioridad'),
  actions: {
    submit: function() {
      this.get('model').save();
      this.get('controllers.application').notify('Solicitud actualizada');
    }
  }
});