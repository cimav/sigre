/**
 * Created by calderon on 3/12/14.
 */

App.Cliente = DS.Model.extend(Ember.Validations.Mixin, {
    rfc:         DS.attr('string'),
    nombre:      DS.attr('string'),

    validations: {
        rfc: {
            format: { with: /^[A-Za-z]{4}\-\d{6}(?:\-[A-Za-z\d]{3})?$/, allowBlank: false, message: 'debe cumplir con el estandar del RFC'  }
        },
        nombre: {
            length: { minimum: 5, message: 'Al menos 5 caracteres' }
        }
    }

});
