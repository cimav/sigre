App.ArchivosRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('solicitud');
  }
});