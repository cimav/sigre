App.Solicitud = DS.Model.extend({
  codigo: DS.attr('string'),
  notas: DS.attr('string'),
  acuerdos: DS.attr('string'),
  prioridad: DS.attr('number'),
  muestras: DS.hasMany('muestra'),
  servicios: DS.hasMany('servicio'),
  proyecto: DS.belongsTo('proyecto'),
  sede: DS.belongsTo('sede'),
  cliente: DS.belongsTo('cliente'),
  contacto: DS.belongsTo('contacto'),
  cotizaciones: DS.hasMany('cotizacion'),

  string: DS.attr('string'),

  selectsChanges: function () {
    // hack: belongs_to no cambian a Dirty
    // https://github.com/emberjs/data/issues/1188
    // TODO poner en False a isDirty
    //this.set('string', Math.random()); // forzar isDirty
  }.observes('cliente','contacto','sede','proyecto'),

  clienteChanges: function() {
    // TODO pone en null al contacto pero no 'limpia' el select
    // si cambia de cliente, poner al 1er contacto

//    var primerContacto = this.get('cliente.contactos').get('firstObject');
//    this.set('contacto', primerContacto); //App.Contacto.create([{id:null}]));
  }.observes('cliente')


});
