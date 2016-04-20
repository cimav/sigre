App.AlertaNota = DS.Model.extend({
  alerta: DS.belongsTo('alerta'),
  usuario: DS.belongsTo('usuario'),
  mensaje: DS.attr('string'),
  created_at: DS.attr('date')
});