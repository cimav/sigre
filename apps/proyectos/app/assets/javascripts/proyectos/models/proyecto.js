App.Proyecto = DS.Model.extend({
  cuenta: DS.attr('string'),
  nombre: DS.attr('string'),
  descripcion: DS.attr('string'),

  impacto: DS.attr('string'),
  resultado_esperado: DS.attr('string'),
  objetivo_estrategico: DS.attr('string'),
  alcance: DS.attr('string'),
  referencia_externa: DS.attr('string'),
  convenio: DS.attr('string'),
  banco_cuenta: DS.attr('string'),
  presupuesto_autorizado: DS.attr('string'),

  fecha_inicio: DS.attr('date'),
  fecha_fin: DS.attr('date'),
  anio: DS.attr('number'),

  moneda:  DS.belongsTo('moneda'),
  sede:  DS.belongsTo('sede'),
  departamento:  DS.belongsTo('departamento'),
  responsable:  DS.belongsTo('empleado'),

  tipo:  DS.belongsTo('tipo'),
  recurso:  DS.belongsTo('recurso'),
  fondo:  DS.belongsTo('fondo'),

  // http://emberjs.com/guides/models/defining-models/#toc_explicit-inverses
  proyecto_base: DS.belongsTo('proyecto', {inverse: 'sub_proyectos'}),
  sub_proyectos: DS.hasMany('proyecto', {inverse: 'proyecto_base'}),
  sortedSubProyectos: function(){
    return this.get('sub_proyectos').sortBy('cuenta');
  }.property('sub_proyectos.@each.isLoaded'),

  values_belongs_to: DS.attr('string'),

  duracion : function() {
    moment.lang('es');
    var inicio  = moment(this.get('fecha_inicio'));
    var termino = moment(this.get('fecha_fin'));
    var result = termino.diff(inicio, 'days');
    return result;
  }.property('fecha_inicio','fecha_fin'),

  humanise_duracion : function() {
    var result = humaniseDays(this.get('duracion'));
    return result;
  }.property('duracion')

});
