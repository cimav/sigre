App.Empleado = DS.Model.extend({
  nombre_completo:   DS.attr('string'),
  nombre:            DS.attr('string'),
  apellido_paterno:  DS.attr('string'),
  apellido_materno:  DS.attr('string'),
  email:             DS.attr('string'),
  //sede:              DS.belongsTo('sede'),
  //departamento:      DS.belongsTo('departamento'),
  //empleado:          DS.belongsTo('empleado'),
});