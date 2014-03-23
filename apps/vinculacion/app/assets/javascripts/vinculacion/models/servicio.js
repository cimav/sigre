App.Servicio = DS.Model.extend({
  nombre:            DS.attr('string'),
  descripcion:       DS.attr('string'),
  solicitud:         DS.belongsTo('solicitud'),
  consecutivo:       DS.attr('string'),
  codigo:            DS.attr('string'),
  muestras:          DS.hasMany('muestra'),
  servicio_seccion:  function() {
    return 'servicio_' + this.get('id');
  }.property('id'),
  servicio_seccion_hash:  function() {
    return '#servicio_' + this.get('id');
  }.property('id')
});