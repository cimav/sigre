App.ServiciosMuestras = DS.Model.extend({
  servicio: DS.belongsTo('solicitud'),
  muestra:  DS.attr('string')
});