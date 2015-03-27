App.Cotizacion = DS.Model.extend({
  consecutivo: DS.attr('string'),
  fecha_notificacion: DS.attr('date'),
  condicion: DS.attr('number'),
  idioma: DS.attr('number'),
  divisa: DS.attr('number'),
  comentarios: DS.attr('string'),
  observaciones: DS.attr('string'),
  notas: DS.attr('string'),
  codigo: DS.attr('string'),
  status_text: DS.attr('string'),

  precio_venta: DS.attr('number'),
  iva: DS.attr('number'),
  descuento_porcentaje: DS.attr('number'),

  subtotal: DS.attr('number'),
  precio_unitario: DS.attr('number'),

  status: DS.attr('number'),
  msg_notificacion: DS.attr('string'),
  motivo_status: DS.attr('string'),
  motivo_descuento: DS.attr('string'),
  duracion: DS.attr('number'),

  solicitud: DS.belongsTo('solicitud'),

  cotizacion_detalles: DS.hasMany('cotizacion_detalle'),

  subtotal_calculado: function(){
    var dets = this.get('cotizacion_detalles');
    var ret = 0;
    dets.forEach(function(d){
      ret += d.get("total");
    });
    this.set('subtotal', ret);
    return ret;
  }.property('cotizacion_detalles.@each.cantidad', 'cotizacion_detalles.@each.precio_unitario'),

  tiempo_entrega_txt: function() {
    var tiempo_entrega = this.get('solicitud.tiempo_entrega');
    switch(tiempo_entrega) {
      case 1: return 'Normal';
      case 2: return 'Urgente';
      case 3: return 'Express';
      default: return 'Normal';
      }
  }.property(),

  descuento_calculado: function() {
    return this.get('subtotal_calculado') * this.get('descuento_porcentaje') / 100;
  }.property('subtotal_calculado', 'descuento_porcentaje'),

  precio_venta_calculado: function() {
    // PrecioVenta = SubTotal - Descuento
    var result = this.get('subtotal_calculado') - this.get('descuento_calculado');
    this.set('precio_venta', result);
    return result;
  }.property('subtotal_calculado', 'descuento_porcentaje'),

  iva_calculado: function() {
    return this.get('precio_venta') * this.get('iva') / 100;
  }.property('precio_venta', 'iva'),

  total_calculado: function() {
    return this.get('precio_venta') + this.get('iva_calculado');
  }.property('precio_venta', 'iva_calculado')

});

