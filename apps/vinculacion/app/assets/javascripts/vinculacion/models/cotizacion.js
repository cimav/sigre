App.Cotizacion = DS.Model.extend({
  consecutivo: DS.attr('string'),
  fecha_notificacion: DS.attr('date'),
  condicion: DS.attr('number'),
  idioma: DS.attr('number'),
  divisa: DS.attr('number'),
  comentarios: DS.attr('string'),
  observaciones: DS.attr('string'),
  notas: DS.attr('string'),
  subtotal: DS.attr('number'),
  precio_venta: DS.attr('number'),
  precio_unitario: DS.attr('number'),
  descuento_porcentaje: DS.attr('number'),
  descuento_status: DS.attr('number'),
  status: DS.attr('number'),

  solicitud: DS.belongsTo('solicitud'),

  sumaTest: function () {
    subtotal = this.get('subtotal');
    precio_venta = this.get('precio_venta');
    result = subtotal + precio_venta;
    return result;
  }.property('subtotal', 'precio_venta')

});

