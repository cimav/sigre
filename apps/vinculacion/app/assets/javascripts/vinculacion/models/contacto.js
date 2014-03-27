App.Contacto = DS.Model.extend(Ember.Validations.Mixin,{
    nombre:     DS.attr('string'),
    telefono:   DS.attr('string'),
    email:      DS.attr('string'),
    cliente:    DS.belongsTo('cliente'),

    validations: {
        nombre: {
            presence: {message: 'debe capturar nombre'}
        }
//        ,
//        telefono: {
//            format: { with: /^\+?\d{1,3}?[- .]?\(?(?:\d{2,3})\)?[- .]?\d\d\d[- .]?\d\d\d\d$/, allowBlank: true, message: 'debe cumplir con el estandar de teléfonos'  }
//        },
//        email: {
//            format: { with: /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$/, allowBlank: true, message: 'debe cumplir con el estandar de email'  }
//        }
    }

});

