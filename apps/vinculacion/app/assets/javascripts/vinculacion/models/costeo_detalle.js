App.CosteoDetalle = DS.Model.extend({
  costeo:           DS.belongsTo('costeo'),
  tipo:             DS.attr('number'),
  descripcion:      DS.attr('string'),
  cantidad:         DS.attr('number'),
  precio_unitario:  DS.attr('number'),
  status:           DS.attr('number')
});