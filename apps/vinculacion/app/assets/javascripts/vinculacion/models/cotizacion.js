App.Cotizacion = DS.Model.extend({
  consecutivo: DS.attr('string'),
  fecha_notificacion: DS.attr('date'),
  condicion: DS.attr('number'),
  idioma: DS.attr('number'),
  divisa: DS.attr('number'),
  comentarios: DS.attr('string'),
  observaciones: DS.attr('string'),
  notas: DS.attr('string'),

  precio_venta: DS.attr('number'),
  iva: DS.attr('number'),
  descuento_porcentaje: DS.attr('number'),
  descuento_status: DS.attr('number'),

  subtotal: DS.attr('number'),
  precio_unitario: DS.attr('number'),

  status: DS.attr('number'),
  msg_notificacion: DS.attr('string'),
  motivo_status: DS.attr('string'),
  duracion: DS.attr('number'),

  solicitud: DS.belongsTo('solicitud'),

  cotizacion_detalles: DS.hasMany('cotizacion_detalle'),

  subtotal_calculado: function(){
    var dets = this.get('cotizacion_detalles');
    var ret = 0;
    dets.forEach(function(d){
      ret += d.get("total");
    });
    return ret;
  }.property('cotizacion_detalles.@each.cantidad', 'cotizacion_detalles.@each.precio_unitario'),

  descuento_calculado: function() {
    return this.get('subtotal_calculado') * this.get('descuento_porcentaje') / 100;
  }.property('subtotal_calculado', 'descuento_porcentaje'),

  subtotal_con_descuento: function() {
    return this.get('subtotal_calculado') - this.get('descuento_calculado');
  }.property('subtotal_calculado', 'descuento_calculado'),

  iva_calculado: function() {
    return this.get('subtotal_con_descuento') * this.get('iva') / 100;
  }.property('subtotal_con_descuento', 'iva'),

  total_calculado: function() {
    return this.get('subtotal_con_descuento') + this.get('iva_calculado');
  }.property('subtotal_con_descuento', 'iva_calculado')

});

