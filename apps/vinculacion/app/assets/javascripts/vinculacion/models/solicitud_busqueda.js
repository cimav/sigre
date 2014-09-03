App.SolicitudBusqueda = DS.Model.extend({
  codigo: DS.attr('string'),
  descripcion: DS.attr('string'),
  prioridad: DS.attr('number'),
  cliente_razon_social: DS.attr('string'),
  cliente_nombre: DS.attr('string'),
  contacto_nombre: DS.attr('string'),
  proyecto_cuenta: DS.attr('string'),
  proyecto_nombre: DS.attr('string'),
  muestras_length: DS.attr('string'),
  servicios_length: DS.attr('string'),
  ultima_cotizacion: DS.attr('string'),
  status_text: DS.attr('string')
});