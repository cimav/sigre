App.TransmitirCedulaController = Ember.ObjectController.extend({
    needs: ['application','cedula'],
    isNotDirty: Ember.computed.not('content.isDirty'),

    actions: {

        transmitir_cedula: function (cedula) {
            self = this;
            cedula.save().then(onSuccess, onFail);
        }
    }

});