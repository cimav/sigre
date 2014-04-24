App.CotizacionDetalle = DS.Model.extend({
  cantidad: DS.attr('number'),
  concepto: DS.attr('string'),
  precio_unitario: DS.attr('number'),
  cotizacion: DS.belongsTo('cotizacion')
});