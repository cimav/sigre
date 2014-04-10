App.CotizacionController = Ember.ObjectController.extend({
  needs: ['application', 'cotizaciones', 'solicitud'],
  showCotizacion: true,
  showToolBar: true,

  Status: {
    edicion: 1,
    notificado: 2,
    aceptado: 3,
    rechazado: 4,
    cancelado: 5
  },

  status_text: [
    {id: 1, texto: 'Edición'},
    {id: 2, texto: 'Notificado'},
    {id: 3, texto: 'Aceptado'},
    {id: 4, texto: 'Rechazado'},
    {id: 5, texto: 'Cancelado'}
  ],

  isEdicion: function () {
    return this.get('model.status') == this.get('Status.edicion');
  }.property('model.status'),
  isNotificado: function () {
    return this.get('model.status') == this.get('Status.notificado');
  }.property('model.status'),


  porcentaje_indirectos: function () {
    // %% de luz, agua, etc.
    return 17.26;
  }.property(),

  costos_variables: function () {
    // TODO sumatorio de los Costeos
    return 195.83;
  }.property(),

  importe_indirectos: function () {
    // TODO redondeo?
    var result = this.get('porcentaje_indirectos') *  this.get('costos_variables') / 100;
    return result;
  }.property('costos_variables'),

  costo_cimav: function() {
    var result = this.get('costos_variables') +  this.get('importe_indirectos');
    return result;
  }.property('costos_variables','importe_indirectos'),

  margen_precio_venta: function() {
    var result = this.get('model.precio_venta') -  this.get('costo_cimav');
    return result;
  }.property('model.precio_venta', 'costo_cimav'),

  remanente_topado: function() {
    // el remanente a distribuir esta topado al 70% del margen del PV
    var porcen = 70;
    var result = porcen * this.get('margen_precio_venta') / 100;
    return result;
  }.property('margen_precio_venta'),

  remanente_distribuible: function() {
    // 35 % del remanente topado es el distribuible
    var porcen = 35;
    var result = porcen * this.get('remanente_topado') / 100;
    return result;
  }.property('remanente_topado'),

  descuento_calculado: function() {
    var result = this.get('model.descuento_porcentaje') * this.get('model.precio_venta') / 100;
    return result;
  }.property('model.descuento_porcentaje','model.precio_venta'),

  descuento_aplicado: function() {
    var result = this.get('model.precio_venta') - this.get('descuento_calculado');
    return result;
  }.property('model.precio_venta','descuento_calculado'),

  iva_calculado: function() {
    //TODO probablemente sea el SubTotal y no directamente el PrecioVenta
    var result = this.get('model.iva') * this.get('descuento_aplicado') / 100;
    return result;
  }.property('model.iva', 'model.precio_venta'),

  total: function() {
    var result = this.get('descuento_aplicado') + this.get('iva_calculado');
    return result;
  }.property('model.precio_venta', 'calculo_iva')

});

