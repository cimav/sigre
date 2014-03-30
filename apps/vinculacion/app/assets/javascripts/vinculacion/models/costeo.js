App.Costeo = DS.Model.extend({
  codigo:          DS.attr('string'),
  nombre_servicio: DS.attr('string'),
  muestra:         DS.belongsTo('muestra'),
  servicio:        DS.belongsTo('servicio'),
  costeo_detalle:  DS.hasMany('costeo_detalle'),
  status:          DS.attr('number')
});