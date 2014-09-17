App.Recurso = DS.Model.extend({
  nombre: DS.attr('string'),
  descripcion:  DS.attr('string'),
  tipo: DS.belongsTo('tipo')
});