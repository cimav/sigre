App.ClienteRoute = Ember.Route.extend({

  beforeModel: function() {
    if (this.modelFor('proyecto')  !== undefined && this.modelFor('proyecto').get('isDirty')) {
      //deshace los cambios del proyecto anterior
      this.modelFor('proyecto').rollback();
    }
  }

});