App.Sede = DS.Model.extend({
  nombre:            DS.attr('string'),
  descripcion:       DS.attr('string'),
  empleados:         DS.hasMany('empleado')
});