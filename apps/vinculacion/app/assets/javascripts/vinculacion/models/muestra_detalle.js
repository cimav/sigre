App.MuestraDetalle = DS.Model.extend({
  muestra: DS.belongsTo('muestra'),
  consecutivo: DS.attr('number'),
  cliente_identificacion: DS.attr('string'),
  notas: DS.attr('string'),
  status: DS.attr('number')
});