App.Servicio = DS.Model.extend({
  nombre: DS.attr('string'),
  descripcion: DS.attr('string'),
  solicitud: DS.belongsTo('solicitud'),
  empleado: DS.belongsTo('empleado'),
  consecutivo: DS.attr('string'),
  codigo: DS.attr('string'),
  status: DS.attr('number'),
  muestras: DS.hasMany('muestra'),
  costeos: DS.hasMany('costeo'),

  status_text: DS.attr('string'),
  muestras_string: DS.attr('string')

});