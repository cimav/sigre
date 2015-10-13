App.Muestra = DS.Model.extend({
  codigo:            DS.attr('string'),
  identificacion:    DS.attr('string'),
  descripcion:       DS.attr('string'),
  cantidad:          DS.attr('number'),
  solicitud_id:      DS.attr('number'),
  solicitud:         DS.belongsTo('solicitud'),
  servicio:          DS.belongsTo('servicio'),
  status:            DS.attr('number'),

  muestras_detalle: DS.hasMany('muestra_detalle'),

  descripcionLarga: function() {
    return this.get('codigo') + ' ' + this.get('identificacion') + ' ' + this.get('descripcion');
  }.property('codigo'),

  rango: function() {
    var result = "Rango";
    if(this.get('muestras_detalle.length') == 1) {
      result = String("000" + this.get('muestras_detalle').get('firstObject').get('consecutivo')).slice(-3);
    } else if(this.get('muestras_detalle.length') > 1) {
      result = String("000" + this.get('muestras_detalle').get('firstObject').get('consecutivo')).slice(-3);
      result = result + " - " + String("000" + this.get('muestras_detalle').get('lastObject').get('consecutivo')).slice(-3);
    }
    return result;
  }.property('muestras_detalle.length')

});
