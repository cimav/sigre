App.Cliente = DS.Model.extend(Ember.Validations.Mixin, {
  rfc: DS.attr('string'),
  razon_social: DS.attr('string'),
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
