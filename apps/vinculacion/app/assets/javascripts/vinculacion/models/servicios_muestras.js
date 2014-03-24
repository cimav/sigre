App.ServiciosMuestras = DS.Model.extend({
  servicio: DS.belongsTo('servicio'),
  muestra:  DS.belongsTo('muestra')
});