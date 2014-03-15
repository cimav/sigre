App.Muestra = DS.Model.extend({
  codigo:            DS.attr('string'),
  identificacion:    DS.attr('string'),
  descripcion:       DS.attr('string'),
  cantidad:          DS.attr('number'),
  solicitud_id:      DS.attr('number'),
  solicitud:         DS.belongsTo('solicitud')
});