App.Sede = DS.Model.extend({
  nombre:            DS.attr('string'),
  descripcion:       DS.attr('string'),
  sede:              DS.hasMany('empleado')
});