
App.ContactoController = Ember.ObjectController.extend({

  actions: {
    update: function() {
      console.log('update DOCE');
    }
  }

//    needs: ['application'],
//
//    isNotDirty: Ember.computed.not('content.isDirty'),
//
//    actions: {
//
//        addContacto: function(cliente) {
//            var self = this;
//            var newContacto = cliente.get('newContacto');
//
//            // todo comprobar que no sean undefined
////            newContacto.set('nombre', newContacto.get('nombre').toUpperCase());
////            newContacto.set('email', newContacto.get('email').toUpperCase());
//
//            var onSuccess = function(contacto) {
//                self.transitionToRoute('cliente', contacto.get('cliente').id);
//                self.get('controllers.application').notify('Se agrego nuevo contacto');
//
//                // al guardar el nuevo, generar el siguiente nuevo vacio
//                cliente.set('newContacto', cliente.store.createRecord('contacto'));
//            };
//            var onFail = function(contacto) {
//                self.get('controllers.application').notify('Error al agregar contacto', 'alert-danger');
//            };
//            if (newContacto.get('isValid')) {
//                // agregar el NuevoContacto a Client.Contactos antes de guardarlo
//                cliente.get('contactos').pushObject(newContacto); // agregar al Contacto a Cliente.Contactos
//                newContacto.save().then(onSuccess, onFail);
//            }
//
//        },
//
//        update: function (contacto) {
//            contacto.save();
//            this.controllerFor('application').notify('Contacto actualizado');
//            this.transitionTo('contacto');
//        }
//    }

});

