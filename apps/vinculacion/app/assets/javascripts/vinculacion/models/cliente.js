App.Cliente = DS.Model.extend(Ember.Validations.Mixin, {
  rfc: DS.attr('string'),
  razon_social: DS.attr('string'),
  num_empleados: DS.attr('number'),
  calle_num: DS.attr('string'),
  colonia: DS.attr('string'),
  cp: DS.attr('string'),
  telefono: DS.attr('string'),
  fax: DS.attr('string'),
  email: DS.attr('string'),
  tamano_empresa: DS.attr('number'),
  sector: DS.attr('number'),
  pais: DS.belongsTo('pais'),
  estado: DS.belongsTo('estado'),
  ciudad: DS.attr('string'),

  contactos: DS.hasMany('contacto', { dependent: 'destroy' }),
  solicitudes: DS.hasMany('solicitud')


  ,validations: {
//    rfc: {
//      format: { with: /^[A-Za-z]{4}\-\d{6}(?:\-[A-Za-z\d]{3})?$/, allowBlank: false, message: 'debe cumplir con el estándar del RFC'  }
//    },
    razon_social: {
      presence: {message: 'requerido'},
      length: {minimum: 5, message: 'al menos 5 caracteres'}
    }
  }

});
