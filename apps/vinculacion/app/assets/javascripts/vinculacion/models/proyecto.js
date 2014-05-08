App.Proyecto = DS.Model.extend(Ember.Validations.Mixin, {
  codigo: DS.attr('string'),
  nombre: DS.attr('string'),
  descripcion: DS.attr('string'),
  obj_proyecto: DS.attr('string'),
  impacto: DS.attr('string'),
  resultado_esperado: DS.attr('string'),
  obj_estrategico: DS.attr('string'),
  anio: DS.attr('number'),
  fecha_inicio: DS.attr('date'),
  fecha_termino: DS.attr('date'),
  status: DS.attr('number'),
  solicitudes: DS.hasMany('solicitud', {async: true}),

  validations: {
    codigo: { presence: {message: 'requerido'}},
    nombre: { presence: {message: 'requerido'}}
  }

});
