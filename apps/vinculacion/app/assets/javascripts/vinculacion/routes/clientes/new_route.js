/**
 * Created by calderon on 3/12/14.
 */
App.ClientesNewRoute = Ember.Route.extend({
    model: function() {
        return this.store.createRecord('cliente');
    },
    actions: {
        create: function(cliente) {
            self = this
            var onSuccess = function(cliente) {
                self.transitionTo('cliente', cliente);
                self.controllerFor('application').notify('Se agrego nuevo cliente');
            };

            var onFail = function(cliente) {
                self.controllerFor('application').notify('Error al agregar cliente', 'alert-error');
            };

            cliente.save().then(onSuccess, onFail);
        }
    }
});