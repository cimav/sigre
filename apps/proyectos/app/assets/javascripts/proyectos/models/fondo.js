App.Fondo = DS.Model.extend({
  nombre: DS.attr('string'),
  descripcion:  DS.attr('string'),
  recurso: DS.belongsTo('recurso')
});