App.Cliente = DS.Model.extend(Ember.Validations.Mixin, {
  rfc: DS.attr('string'),
  razon_social: DS.attr('string'),
  contactos: DS.hasMany('contacto'),

  validations: {
    rfc: {
      format: { with: /^[A-Za-z]{4}\-\d{6}(?:\-[A-Za-z\d]{3})?$/, allowBlank: false, message: 'debe cumplir con el estandar del RFC'  }
    },
    razon_social: {
      length: { minimum: 5, message: 'Al menos 5 caracteres' }
    }
  }

});
