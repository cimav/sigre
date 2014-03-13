/**
 * Created by calderon on 3/12/14.
 */

App.ClientesRoute = Ember.Route.extend({
    model: function() {
        this.store.find('cliente');
        return this.store.filter(App.Cliente, function(cliente) {
            return !cliente.get('isNew');
        })
    },
    actions: {
        delete: function(cliente) {
            cliente.destroyRecord();
        }
    }
});