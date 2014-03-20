App.Servicio = DS.Model.extend({
  nombre:            DS.attr('string'),
  descripcion:       DS.attr('string'),
  solicitud:         DS.belongsTo('solicitud')
});