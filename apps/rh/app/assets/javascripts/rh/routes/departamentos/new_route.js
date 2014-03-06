App.DepartamentosNewRoute = Ember.Route.extend({
  model: function() {
    //return this.store.createRecord('departamento');
    // FIXME: Debe ser asi ^^^, este es un hack vvvv
    return App.Departamento.createRecord();
  },
  actions: {
    create: function(departamento) {
      departamento.one('didCreate', this, function(){
        this.transitionTo('departamento', departamento);
        this.controllerFor('application').notify('Se agrego nuevo departamento');
      });
      departamento.get('transaction').commit();

    }
  }
});