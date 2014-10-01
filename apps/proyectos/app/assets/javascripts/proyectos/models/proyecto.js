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
  }.property('duracion'),

//  sortProperties: ['cuenta:desc'],
//  sortedProyectos: Ember.computed.sort('model', 'sortProperties'),
//  proyectosBase2: Ember.computed.filter('sortedProyectos2', function(proyecto) {
//    return proyecto.get('isProyectoBase');
//  }).property('id'),
//
//  proyectosBaseN: function(){
//    var r = Ember.A();
//    Promise.all([
//      this.store.find('proyecto')
//    ]).then(function(values){
//      r.push(values[0]);
//      return values;
//    });
////    var p = this.store.find('proyecto').then( function(result) {
////      r.push(result);
////    });
//    return r; //this.get('proyectosBase1');
//  }.property('model.id')

//  lista: function() {
//    var result = Ember.A();
////    var proys = this.store.filter('proyecto', {unread: true}, function (proyectos) {
////      result.push(proyectos);
////    });
//    result.push(this.store.all('proyecto'));
//    return result;
//  }.property('id')


});
