App.SedesNewRoute = Ember.Route.extend({
  model: function() {
    //return this.store.createRecord('sede');
    // FIXME: Debe ser asi ^^^, este es un hack vvvv
    return App.Sede.createRecord();
  },
  actions: {
    create: function(sede) {
      sede.one('didCreate', this, function(){
        this.transitionTo('sede', sede);
        this.controllerFor('application').notify('Se agrego nueva sede');
      });
      sede.get('transaction').commit();

    }
  }
});