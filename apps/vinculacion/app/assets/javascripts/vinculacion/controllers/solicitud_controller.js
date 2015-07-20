App.SolicitudController = Ember.ObjectController.extend({
  needs: ["muestras", "application"],
  isNotDirty: Ember.computed.not('content.isDirty'),
  muestrasCount: Ember.computed.alias('content.muestras.length'),
  serviciosCount: Ember.computed.alias('content.servicios.length'),
  prioridad_item: App.computed.list_item('prioridad'),
  canEdit: function(){
    var status = this.get('model.status');
    var inicial = this.get('model.Status.inicial');
    var en_cotizacion = this.get('model.Status.en_cotizacion');
    var result = status == inicial || status == en_cotizacion;
    return result;
  }.property('model.status'),
  allowAddServicios: function() {
    // permitir agregar nuevos servicios cuando la solicitud esta en inicial, en_cotizacion o aceptada
    var inicial = this.get('model.Status.inicial');
    var en_cotizacion = this.get('model.Status.en_cotizacion');
    var aceptada = this.get('model.Status.aceptada');
    var status = this.get('model.status');
    var result = status == inicial || status == en_cotizacion || status == aceptada;
    // y que no sea del Tipo 1
    return result && !this.get('model.isTipoI');
  }.property('model.status'),
  
  pdf_url: function() {
    return '/vinculacion/recepcion_muestras/' + this.get('id')
  }.property('model.id')

});

