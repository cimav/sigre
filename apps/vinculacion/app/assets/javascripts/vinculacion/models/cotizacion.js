App.Cotizacion = DS.Model.extend({
  consecutivo: DS.attr('string'),
  fecha_notificacion: DS.attr('date'),
  condicion: DS.attr('number'),
  idioma: DS.attr('number'),
  divisa: DS.attr('number'),
  comentarios: DS.attr('string'),
  observaciones: DS.attr('string'),
  notas: DS.attr('string'),

  precio_venta: DS.attr('number'),
  iva: DS.attr('number'),
  descuento_porcentaje: DS.attr('number'),
  descuento_status: DS.attr('number'),

  subtotal: DS.attr('number'),
  precio_unitario: DS.attr('number'),

  status: DS.attr('number'),
  msg_notificacion: DS.attr('string'),
  motivo_status: DS.attr('string'),
  duracion: DS.attr('number'),

  solicitud: DS.belongsTo('solicitud')

});

