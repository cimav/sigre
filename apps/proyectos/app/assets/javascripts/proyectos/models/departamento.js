App.Departamento = DS.Model.extend({
  nombre:       DS.attr('string'),
  descripcion:  DS.attr('string'),

  sede: DS.belongsTo('sede'),
  empleados: DS.hasMany('empleado')

});