App.ContactosIndexController = Ember.ObjectController.extend({
  needs: ['application', 'cliente'],

  deleteMode: false,

  actions: {

    update: function (contacto) {
      this.get('controllers.application').notify('UPDATE DIEZ');
    },

    delete: function (contacto) {
      // our delete method now only toggles deleteMode's value
      this.toggleProperty('deleteMode');
      contactoToDelete = contacto;
    },
    cancelDelete: function () {
      // set deleteMode back to false
      this.set('deleteMode', false);
    },
    confirmDelete: function () {
      // this tells Ember-Data to delete the current user
      contactoToDelete.deleteRecord();
      contactoToDelete.save();

      // set deleteMode back to false
      this.set('deleteMode', false);
      // and then go to the clientes
      this.transitionToRoute('contactos.index');

      self.get('controllers.application').notify('Contacto eliminado');
    }

  }

});