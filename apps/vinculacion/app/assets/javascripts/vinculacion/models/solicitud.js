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
  status: DS.attr('string'),
  razon_cancelacion: DS.attr('string'),
  motivo_status: DS.attr('string'),

  status_text:       DS.attr('string'),
  relation_string: DS.attr('string'),

  Status: {
    inicial: 1,
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
  }.property('status')

});
