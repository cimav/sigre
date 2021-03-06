App.Solicitud = DS.Model.extend({
  codigo: DS.attr('string'),
  descripcion: DS.attr('string'),
  prioridad: DS.attr('number'),
  muestras: DS.hasMany('muestra'),
  servicios: DS.hasMany('servicio'),
  alertas: DS.hasMany('alerta'),
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
  usuario: DS.belongsTo('usuario'),
  created_at: DS.attr('date'),
  vinculacion_hash: DS.attr('string'),

  precio_venta: DS.attr('number'),
  costo_interno: DS.attr('number'),

  status_text:       DS.attr('string'),
  relation_string: DS.attr('string'),

  tipo: DS.attr('number'),
  tiempo_entrega: DS.attr('number'),

  Status: {
    inicial: 1,
    en_cotizacion: 2,
    aceptada: 3,
    en_proceso: 4,
    finalizada: 5,
    cancelada: 99
  },

  selectsChanges: function () {
    if (!this.get('isDeleted')) {
      // Hack: belongsTo no cambian a Dirty
      // Info de porque no cambian: https://github.com/emberjs/data/issues/1188
      s = [this.get('proyecto.id'), this.get('sede.id'), this.get('cliente.id'), this.get('contacto.id'), this.get('cliente_netmultix.id'), this.get('contacto_netmultix.id')].join(',');
      this.set('relation_string', s);
    }
  }.observes('cliente','contacto','sede','proyecto', 'cliente_netmultix', 'contacto_netmultix'),

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

  mostrarCedulas: function() {
    return this.get('status') >= this.get('Status.en_proceso');
  }.property('status'),

  setFechaTermino: function() {
    var f_termino = this.addBusinessDay(this.get('fecha_inicio'), parseInt(this.get('duracion')));
    this.set('fecha_termino', f_termino);
  }.observes('duracion', 'fecha_inicio'),

  addBusinessDay: function(f_inicio, daysToAdd) {
    var f_termino = new Date(f_inicio);
    while(daysToAdd > 0) {
      f_termino.setTime( f_termino.getTime() + 24 * 3600 * 1000 ); // add one day
      if ( f_termino.getUTCDay() != 0 && f_termino.getUTCDay() != 6 ) --daysToAdd;
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

  alertUrl: function() {
    //return this.get('servicioNoCoordinado.bitacora_id');
    s = this.get('servicios').get('firstObject');
    sid = s.get('servicio_bitacora.id');
    return  "http://bitacora.cimav.edu.mx/laboratory_services/" + sid + "/status";
  }.property('servicioNoCoordinado'),

  archivosUrl: function() {
    id = this.get('id');
    return  "/vinculacion/solicitudes/" + id + "/archivos";
  }.property('muestras'),


  isTipoI: function() {
    var result = this.get('tipo') == 1;
//    if (!result) {
//      // para Tipo II y III, tiempo_entrega = Normal
//      this.set('tiempo_entrega', 1);
//    }
    return result;
  }.property('tipo'),

  isTipoII: function() {
    var result = this.get('tipo') == 2;
    return result;
  }.property('tipo'),

  isTipoIII: function() {
    var result = this.get('tipo') == 3;
    return result;
  }.property('tipo'),

  isTipoProyecto: function() {
    var result = this.get('tipo') == 4;
    return result;
  }.property('tipo'),

  tipoText: function() {
    switch (this.get('tipo')) {
      case 1: return 'Tipo I';
      case 2: return 'Tipo II';
      case 3: return 'Tipo III';
      case 4: return 'Proyecto';
    }
    return 'Sin tipo';
  }.property('tipo'),

  tiempoEntregaText: function() {
    switch (this.get('tiempo_entrega')) {
      case 1: return 'Normal';
      case 2: return 'Urgente';
      case 3: return 'Express';
    }
    return 'Sin tiempo de entrega';
  }.property('tiempo_entrega'),

    fecha_presupuestal: function() {
      /*
      console.log('Fecha>',moment().add(4, 'days').toDate());
      var result = new Date();
      result.setDate(this.get('fecha_termino').getDate() + 10);
      return result;
      */
      // return moment(this.get('fecha_termino').getDate(), 'DD-MM-YYYY').businessAdd(10)._d;
        return moment(this.get('fecha_termino')).add(10, 'days').toDate();
    }.property('fecha_termino'),

});