App.Departamento = DS.Model.extend({
  nombre:            DS.attr('string'),
  descripcion:       DS.attr('string'),
  sede:              DS.belongsTo('App.Sede'),
  departamento:      DS.belongsTo('App.Departamento'),
});
