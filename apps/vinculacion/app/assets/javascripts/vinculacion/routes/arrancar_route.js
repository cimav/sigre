App.ArrancarRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('solicitud');
  },

  beforeModel: function() {
    if (this.modelFor('solicitud')  !== undefined && this.modelFor('solicitud').get('isDirty')) {
      //deshace los cambios de la solicitud anterior
      this.modelFor('solicitud').rollback();
    }
  }
});