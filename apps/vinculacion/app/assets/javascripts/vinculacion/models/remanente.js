App.Remanente = DS.Model.extend({

  cedula: DS.belongsTo('cedula'),
  empleado: DS.belongsTo('empleado'),
  porcentaje_participacion: DS.attr('number'),
  monto: DS.attr('number')

});