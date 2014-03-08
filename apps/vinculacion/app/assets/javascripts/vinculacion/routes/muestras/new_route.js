App.MuestrasNewRoute = Ember.Route.extend({
  model: function() {
    //return this.store.createRecord('muestra');
    // FIXME: Debe ser asi ^^^, este es un hack vvvv
    return App.Muestra.createRecord();
  },
  actions: {
    create: function(muestra) {
      muestra.one('didCreate', this, function(){
        this.transitionTo('muestra', muestra);
        this.controllerFor('application').notify('Se agrego nueva muestra');
      });
      muestra.get('transaction').commit();

    }
  }
});