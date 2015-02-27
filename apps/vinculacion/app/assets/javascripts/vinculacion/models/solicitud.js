App.Solicitud = DS.Model.extend({
  codigo: DS.attr('string'),
  descripcion: DS.attr('string'),
  prioridad: DS.attr('number'),
  muestras: DS.hasMany('muestra'),
  servicios: DS.hasMany('servicio'),
  proyecto: DS.belongsTo('proyecto'),
  sede: DS.belongsTo('sede'),
  cliente: DS.belongsTo('cliente'),
  contacto: DS.belongsTo('contacto'),
  cotizaciones: DS.hasMany('cotizacion'),
  status: DS.attr('number'),
  razon_cancelacion: DS.attr('string'),
  motivo_status: DS.attr('string'),
  orden_compra: DS.attr('string'),
  fecha_inicio: DS.attr('date'),
  fecha_termino: DS.attr('date'),
  duracion: DS.attr('number'),
  cedulas: DS.hasMany('cedula'),
  responsable_presupuestal: DS.belongsTo('empleado'),

  precio_venta: DS.attr('number'),
  costo_interno: DS.attr('number'),

  status_text:       DS.attr('string'),
  relation_string: DS.attr('string'),

  tipo: DS.attr('number'),

//  servicio_bitacora: null,

  Status: {
    inicial: 1,
    en_cotizacion: 2,
    aceptada: 3,
    en_proceso: 4,
    finalizada: 5,
    cancelada: 99
  },

  selectsChanges: function () {
    // Hack: belongsTo no cambian a Dirty
    // Info de porque no cambian: https://github.com/emberjs/data/issues/1188
    s = [this.get('proyecto.id'), this.get('sede.id'), this.get('cliente.id'), this.get('contacto.id')].join(',');
    this.set('relation_string', s);
  }.observes('cliente','contacto','sede','proyecto'),

  clienteChanges: function() {
    // TODO pone en null al contacto pero no 'limpia' el select
    // si cambia de cliente, poner al 1er contacto

//    var primerContacto = this.get('cliente.contactos').get('firstObject');
//    this.set('contacto', primerContacto); //App.Contacto.create([{id:null}]));
  }.observes('cliente'),

  lastCotizacion: function() {
    return this.get('cotizaciones').sortBy('consecutivo').get('lastObject');
  }.property('cotizaciones'),

  isCancelada: function() {
    return this.get('status') == this.get('Status.cancelada');
  }.property('status'),

  isAceptada: function() {
    return this.get('status') == this.get('Status.aceptada');
  }.property('status'),

  isEnProceso: function() {
    return this.get('status') == this.get('Status.en_proceso');
  }.property('status'),

  setFechaTermino: function() {
    var f_termino = this.addBusinessDay(this.get('fecha_inicio'), parseInt(this.get('duracion')));
    this.set('fecha_termino', f_termino);
  }.observes('duracion', 'fecha_inicio'),

  addBusinessDay: function(f_inicio, daysToAdd) {
    var f_termino = new Date(f_inicio);
    while(daysToAdd > 0) {
      f_termino.setTime( f_termino.getTime() + 24 * 3600 * 1000 ); // add one day
      if ( f_termino.getDay() != 0 && f_termino.getDay() != 6 ) --daysToAdd;
    }
    return f_termino;
  },

  hasMuestras: function() {
    return this.get('muestras.length') > 0;
  }.property('muestras'),

  muestraNoCoordinado: function() {
    return this.get('muestras').get('firstObject');
  }.property('muestras'),

  hasServicios: function() {
    return this.get('servicios.length') > 0;
  }.property('servicios'),

  servicioNoCoordinado: function() {
    return this.get('servicios').get('firstObject');
  }.property('servicios'),

  isTipoI: function() {
    return this.get('tipo') == 1;
  }.property('tipo')

});
