App.Servicio = DS.Model.extend({
  nombre:            DS.attr('string'),
  descripcion:       DS.attr('string'),
  solicitud:         DS.belongsTo('solicitud'),
  empleado:          DS.belongsTo('empleado'),
  consecutivo:       DS.attr('string'),
  codigo:            DS.attr('string'),
  status:            DS.attr('number'),
  muestras:          DS.hasMany('muestra'),


  muestras_string:   DS.attr('string'),

  isInicial: Ember.computed.equal('status', 1),
  isEsperandoCosteo: Ember.computed.equal('status', 2),
  
  status_text: function() {
    var status_text = 'Desconocido';
    if (this.get('status') == 1) {
      status_text = 'Inicial';
    } else if (this.get('status') == 2) {
      status_text = 'Esperando Costeo'
    } 
    return status_text;
  }.property('status')

});