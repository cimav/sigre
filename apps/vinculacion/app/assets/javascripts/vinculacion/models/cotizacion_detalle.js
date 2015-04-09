App.CotizacionDetalle = DS.Model.extend({
  cantidad: DS.attr('number'),
  concepto: DS.attr('string'),
  precio_unitario: DS.attr('number'),
  cotizacion: DS.belongsTo('cotizacion'),
  servicio_id: DS.attr('number'),
  inmutable: DS.attr('boolean'),
  total: function() {
    return this.get('cantidad') * this.get('precio_unitario');
  }.property('cantidad', 'precio_unitario')
});