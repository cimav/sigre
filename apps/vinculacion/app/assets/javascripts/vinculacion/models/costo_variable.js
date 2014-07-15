App.CostoVariable = DS.Model.extend({

  cedula: DS.belongsTo('cedula'),
  tipo: DS.attr('number'),
  descripcion: DS.attr('string'),
  costo: DS.attr('number')

});
