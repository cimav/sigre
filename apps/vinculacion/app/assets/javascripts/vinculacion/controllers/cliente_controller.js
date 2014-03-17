/**
 * Created by calderon on 3/12/14.
 */
App.ClienteController = Ember.ObjectController.extend({
    needs: ['application', 'clientes'],

    isNotReadyForSave: function() {
        var result = this.get('content.isDirty') == true && this.get('content.isValid') == true;
        console.log(!result);
        return !result;
    }.property('content.isDirty','content.isValid'),


    actions: {
        update: function () {
            self = this
            var onSuccess = function (cliente) {
                self.transitionToRoute('cliente', cliente);
                self.get('controllers.application').notify('Se actualizó cliente ' + self.get('model.rfc'));
            };
            var onFail = function (cliente) {
                self.get('controllers.application').notify('Error al agregar cliente', 'alert-error');
            };

            console.log(self.get('model').get('isValid'));
            if (self.get('model').get('isValid')) {
                self.get('model').save().then(onSuccess, onFail);
            }

        },
        destroy: function () {
            self = this
            var rfc = self.get('model.rfc');
            if (window.confirm("?Eliminar Cliente: " + rfc + "?")) {
                var onSuccess = function (cliente) {
                    self.get('controllers.clientes').firstCliente(); // transicion al primero
                    self.get('controllers.application').notify('Se eliminó cliente ' + rfc);
                };
                var onFail = function (cliente) {
                    self.get('controllers.application').notify('Error al eliminar cliente', 'alert-error');
                };
                self.get('model').deleteRecord();
                self.get('model').save().then(onSuccess, onFail);
            } else {
                //self.transitionToRoute('cliente', cliente);
            }
        }
    }
});