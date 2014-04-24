App.ContactosController = Ember.ArrayController.extend({
  needs: ['application', 'cliente'],

  showContactos: true,
  deleteMode: false,

  actions: {

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

      this.get('controllers.application').notify('Contacto eliminado');

      // this tells Ember-Data to delete the current
      contactoToDelete.destroyRecord();

      // set deleteMode back to false
      this.set('deleteMode', false);
      // and then go to the contactos
      this.transitionToRoute('contactos');
    }

  }

});