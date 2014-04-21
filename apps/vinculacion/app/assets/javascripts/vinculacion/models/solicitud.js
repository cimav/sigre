App.Solicitud = DS.Model.extend({
  codigo: DS.attr('string'),
  notas: DS.attr('string'),
  acuerdos: DS.attr('string'),
  contacto_email: DS.attr('string'),
  prioridad: DS.attr('number'),
  muestras: DS.hasMany('muestra'),
  servicios: DS.hasMany('servicio'),
  proyecto: DS.belongsTo('proyecto'),
  sede: DS.belongsTo('sede'),
  cliente: DS.belongsTo('cliente'),
  contacto: DS.belongsTo('contacto'),
  cotizaciones: DS.hasMany('cotizacion'),

  selectsChanges: function () {
    // hack: Los Selects de models no ponen por si solos a al model parent en Dirty.
    // nota: probablemente sean los belongs_to los que no cambian a Dirty
    // https://github.com/emberjs/data/issues/1188
    // TODO poner en False a isDirty

  }.observes('cliente','contacto','sede','proyecto')

});
