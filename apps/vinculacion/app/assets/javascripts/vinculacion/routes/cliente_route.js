App.ClienteRoute = Ember.Route.extend({
  afterModel: function () {
    // cada vez que se cambia de Cliente, redireccionarse/cargar la ruta Contactos
    this.transitionTo('contactos');
  },

  beforeModel: function() {
    if (this.modelFor('cliente')  !== undefined && this.modelFor('cliente').get('isDirty')) {
      //deshace los cambios del cliente anterior
      this.modelFor('cliente').rollback();
    }
  }

});