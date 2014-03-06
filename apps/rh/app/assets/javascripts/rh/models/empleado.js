App.Empleado = DS.Model.extend({
  nombre_completo:   DS.attr('string'),
  nombre:            DS.attr('string'),
  apellido_paterno:  DS.attr('string'),
  apellido_materno:  DS.attr('string'),
  email:             DS.attr('string'),
  sede:              DS.belongsTo('App.Sede'),
  departamento:      DS.belongsTo('App.Departamento')
});