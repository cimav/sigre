App.Servicio = DS.Model.extend({
  nombre:            DS.attr('string'),
  descripcion:       DS.attr('string'),
  solicitud:         DS.belongsTo('solicitud'),
  consecutivo:       DS.attr('string'),
  codigo:            DS.attr('string'),
  muestras:          DS.hasMany('muestra'),
  muestras_string:   DS.attr('string'),
  //muestras_map:      DS.attr('array'),
  //muestras_change:  function() {
  //  console.log('Muestras Change...');
    //this.set('muestras_map', this.get('muestras').map(function(el) {  el.id; }).toArray());
  //  var ms = ''
  //  this.get('muestras').map(function(el) {  console.log('M'+el.id); ms = ms + el.id + ','});
  //  console.log(ms);
  //}.observes('muestras.@each'),
  servicio_seccion:  function() {
    return 'servicio_' + this.get('id');
  }.property('id'),
  servicio_seccion_hash:  function() {
    return '#servicio_' + this.get('id');
  }.property('id')
});