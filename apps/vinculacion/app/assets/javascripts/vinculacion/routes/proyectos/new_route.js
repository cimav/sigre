App.ProyectosNewRoute = Ember.Route.extend({
  model: function () {
    return this.store.createRecord('proyecto');
  }
});