App.ContactosRoute = Ember.Route.extend({
  model: function() {
    // return this.modelFor('cliente').get('contactos');
/*
      my_self = this;
      Promise.all([
          my_self.store.find('contacto', { cliente_id: my_self.modelFor('cliente').get('id') })
      ]).then(function(values){
          console.log(values[0].get('length'));
          my_self.modelFor('cliente').set('contactos',values[0]);
          console.log(my_self.modelFor('cliente').get('contactos').get('length'));
          return values[0];
      }, function(reason){
          console.log('Promise Contacto fail: ' + reason);
      });
*/
    return this.store.find('contacto', { cliente_id: this.modelFor('cliente').get('id') });
  }

});