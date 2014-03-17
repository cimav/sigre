/**
 * Created by calderon on 3/12/14.
 */

App.ClienteRoute = Ember.Route.extend({

    model: function() {
        return null;
    }

//    activate: function() {
//        this.controllerFor('clientes').set('showClientesList', true);
//    },
//    deactivate: function() {
//        this.controllerFor('clientes').set('showClientesList', true);
//    }

    // movido a clientes/update_route
//    actions: {
//        update: function(cliente) {
//            cliente.save();
//            this.controllerFor('application').notify('Cliente actualizado');
//            this.transitionTo('cliente');
//        }
//    }

});