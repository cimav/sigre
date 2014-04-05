App.CotizacionController = Ember.ObjectController.extend({
  needs: ['application'],
  showCotizacion: true,

  actions: {
    editar: function() {
      console.log("status: " + this.get('model.status') + " > " + this.Status.editable);
      this.set('model.status', this.Status.editable);
      console.log("nuevo: " + this.get('model.status'));
    },
    notificar: function() {
      console.log("status: " + this.get('model.status') + " > " + this.Status.editable);
      this.set('model.status', 1);
      console.log("nuevo: " + this.get('model.status'));
    },
    aceptar: function() {
      this.set('model.status', 2);
    },
    rechazar: function() {
      this.set('model.status', 3);
    },
    nueva: function() {
      this.set('model.status', 4);
    },
    cancelar: function() {
      this.set('model.status', 5);
    }
  },

//  Status: {
//    editable: 0,
//    notificada: 1,
//    aceptada: 2,
//    rechazada: 3,
//    nueva: 4,
//    cancelada: 5,
//    desconocido: 6
//  },

  status_array: [
    {id: 0, text: 'Editable'},
    {id: 1, text: 'Notificada'},
    {id: 2, text: 'Aceptada'},
    {id: 3, text: 'Rechazada'},
    {id: 4, text: 'Cancelada'},
    {id: 5, text: 'Desconocido'}
  ]


});

