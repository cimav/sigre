App.CosteoDetalle = DS.Model.extend({
  costeo:           DS.belongsTo('costeo'),
  tipo:             DS.attr('number'),
  descripcion:      DS.attr('string'),
  cantidad:         DS.attr('string'),
  precio_unitario:  DS.attr('string'),
  status:           DS.attr('number')
});