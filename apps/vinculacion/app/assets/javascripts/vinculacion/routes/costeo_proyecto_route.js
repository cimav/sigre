App.CosteoProyectoRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('solicitud').get('servicios').get('firstObject');
  }
});