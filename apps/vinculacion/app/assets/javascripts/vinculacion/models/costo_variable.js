App.CostoVariable = DS.Model.extend({

  cedula: DS.belongsTo('cedula'),
  tipo: DS.attr('string'),
  descripcion: DS.attr('string'),
  costo: DS.attr('number')

});
