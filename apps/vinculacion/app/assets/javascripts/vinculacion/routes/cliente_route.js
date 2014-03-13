/**
 * Created by calderon on 3/12/14.
 */

App.ClienteRoute = Ember.Route.extend({
    actions: {
        update: function(cliente) {
            cliente.save();
            this.controllerFor('application').notify('Cliente actualizado');
            this.transitionTo('cliente');
        }
    }
});