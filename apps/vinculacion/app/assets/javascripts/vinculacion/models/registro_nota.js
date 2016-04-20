App.RegistroNota = DS.Model.extend({
  registro: DS.belongsTo('registro'),
  alerta: DS.belongsTo('alerta'),
  usuario: DS.belongsTo('usuario'),
  mensaje: DS.attr('string'),
  created_at: DS.attr('date')
});

App.RegistroNotum = DS.Model.extend({
  registro: DS.belongsTo('registro'),
  alerta: DS.belongsTo('alerta'),
  usuario: DS.belongsTo('usuario'),
  mensaje: DS.attr('string'),
  created_at: DS.attr('date')
});