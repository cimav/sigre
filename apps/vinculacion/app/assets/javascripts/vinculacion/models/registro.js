App.Registro = DS.Model.extend({
  empleado: DS.belongsTo('empleado'),
  solicitud: DS.belongsTo('solicitud'),
  tipo: DS.attr('string'),
  mensaje: DS.attr('string'),
  status_text: DS.attr('string'),
  status: DS.attr('number'),
  registro_notas: DS.hasMany('registro_nota'),
  created_at: DS.attr('date')
});