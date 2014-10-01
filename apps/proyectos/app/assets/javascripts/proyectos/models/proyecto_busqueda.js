App.ProyectoBusqueda = DS.Model.extend({
  cuenta: DS.attr('string'),
  nombre: DS.attr('string'),
  descripcion: DS.attr('string'),
  fecha_inicio: DS.attr('date'),
  fecha_fin: DS.attr('date'),
  anio: DS.attr('number'),
  sede_text: DS.attr('string'),
  departamento_text: DS.attr('string'),
  tipo_text: DS.attr('string'),
  recurso_text: DS.attr('string'),
  fondo_text: DS.attr('string'),
  moneda_text: DS.attr('string'),
  responsable_text: DS.attr('string'),

  isProyectoBase: DS.attr('boolean'),
  cuenta_proyecto_base: DS.attr('string'),

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
