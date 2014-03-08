App.SolicitudesNewRoute = Ember.Route.extend({
  model: function() {
    return this.store.createRecord('solicitud');
  },
  actions: {
    create: function(solicitud) {
      solicitud.one('didCreate', this, function(){
        this.transitionTo('solicitud', solicitud);
        this.controllerFor('application').notify('Se agrego nuevo solicitud');
      });
      solicitud.get('transaction').commit();

    }
  }
});