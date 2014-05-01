App.SolicitudController = Ember.ObjectController.extend({
  needs: ["muestras", "application"],
  isNotDirty: Ember.computed.not('content.isDirty'),
  muestrasCount: Ember.computed.alias('content.muestras.length'),
  serviciosCount: Ember.computed.alias('content.servicios.length'),
  prioridad_item: App.computed.list_item('prioridad')

});

