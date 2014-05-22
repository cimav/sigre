App.SolicitudController = Ember.ObjectController.extend({
  needs: ["muestras", "application"],
  isNotDirty: Ember.computed.not('content.isDirty'),
  muestrasCount: Ember.computed.alias('content.muestras.length'),
  serviciosCount: Ember.computed.alias('content.servicios.length'),
  prioridad_item: App.computed.list_item('prioridad'),

  allowAddServicios: function() {
    // permitir agregar nuevos servicios cuando la solicitud esta en inicial, en_cotizacion o aceptada
    var inicial = this.get('model.Status.inicial');
    var en_cotizacion = this.get('model.Status.en_cotizacion');
    var aceptada = this.get('model.Status.aceptada');
    var status = this.get('model.status');
    return status == inicial || status == en_cotizacion || status == aceptada;
  }.property('model.status')

});

