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
  }.property('subtotal', 'precio_venta'),


  statusChanged: null,
  oldStatus: null,
  newStatus: null,

  statusBefore: function (obj, keyName) {
    oldStatus = this.get('status');
  }.observesBefore('status'),

  statusAfter: function (obj, keyName) {

    newStatus = this.get('status');

    if (newStatus == oldStatus) {
      return;
    }

    // Permite Nueva solo si anterior es Rechazada
    if (newStatus == 5 && oldStatus != 3) {
      this.rollback();
      //TODO Notificar
      //this.get('controllers.application').notify('Debe Rechazar cotización antes de generar Nueva');
      // TODO Si es Nuava, tiene que regresarse a Rechazada. O a estado Historica. Las anteriores no deben ser editables.
    }
    // Reglas restantes....

    if (this.get('isDirty')) {
      this.save();
      this.set('statusChanged', newStatus);
    }

  }.observesImmediately('status')


});

