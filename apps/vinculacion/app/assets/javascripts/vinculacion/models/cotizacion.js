App.Cotizacion = DS.Model.extend({
  consecutivo:          DS.attr('string'),
  fecha_notificacion:   DS.attr('date'),
  condicion:            DS.attr('number'),
  idioma:               DS.attr('number'),
  divisa:               DS.attr('number'),
  comentarios:          DS.attr('string'),
  observaciones:        DS.attr('string'),
  notas:                DS.attr('string'),
  subtotal:             DS.attr('number'),
  precio_venta:         DS.attr('number'),
  precio_unitario:      DS.attr('number'),
  descuento_porcentaje: DS.attr('number'),
  descuento_status:     DS.attr('number'),
  status:               DS.attr('number'),

  solicitud:            DS.belongsTo('solicitud'),


  sumaTest: function() {
    subtotal = this.get('subtotal');
    precio_venta = this.get('precio_venta');
    result = subtotal + precio_venta;
    return result;
  }.property('subtotal','precio_venta'),


  oldStatus: null,
  newStatus: null,

  statusBefore: function(obj, keyName) {
    oldStatus = obj.get('status');
  }.observesBefore('status'),

  statusAfter: function(obj, keyName) {

//    //Desactivo observers
//    this.removeObserver('status', this, this.get('statusAfter'));
//    this.removeObserver('status', this, this.get('statusBefore'));

    newStatus = obj.get('status');

    if (newStatus == oldStatus) {
      return;
    }

    console.log("Aft " + obj + " : " + keyName + " : " + oldStatus + " : " + newStatus);

//    // confirmar: Aceptada, Rechazada, Cancelada
//    if (newStatus == 2 || newStatus == 3 || newStatus == 4) {
//      var statusText = newStatus; //this.get('controller').get('status_array')[newStatus]["text"];
//      if (!confirm("¿Cambiar Status a: " + statusText + "?")) {
//        this.set('status',oldStatus); // deshago el cambio
//        return;
//      }
//    }

//    // reglas
//    if (oldStatus === 2) {
//      // cambio invalido
//      alert('No se realizo el cambio');
//      this.set('status',oldStatus); // deshago el cambio
//    } else {
//      // cambio valido. Aqui va el codigo.
//
//      // Guarda el cambio de estatus
////      this.save();
//    }

    this.save();

//    //Reactivo observers
//    this.addBeforeObserver('status', this, this.get('statusBefore'));
//    this.addObserver('status', this, this.get('statusAfter'));

  }.observesImmediately('status')


});

