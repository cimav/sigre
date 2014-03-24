App.ContactoEditRoute = Ember.Route.extend({

  model: function(){
    return this.modelFor('contacto');
  },
  deactivate: function(){
    this.transitionTo('contactos.index');
  }

});
