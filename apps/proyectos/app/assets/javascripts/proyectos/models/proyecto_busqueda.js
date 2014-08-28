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
  responsable_text: DS.attr('string')
});
