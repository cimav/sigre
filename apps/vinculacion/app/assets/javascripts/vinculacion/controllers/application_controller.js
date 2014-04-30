App.ApplicationController = Ember.Controller.extend({
  prioridades: [
    {id: 1, descripcion: "Baja"},
    {id: 2, descripcion: "Media"},
    {id: 3, descripcion: "Alta"}
  ],
  condiciones: [
    {id: 1, descripcion:'Contado'},
    {id: 2, descripcion:'Parcial'},
    {id: 3, descripcion:'8 días'},
    {id: 4, descripcion:'15 días'}
  ],
  idiomas: [
    {id: 1, codigo:'ES', descripcion:'Español'},
    {id: 2, codigo:'IN', descripcion:'Inglés'}
  ],
  divisas: [
    {id: 1, codigo:'MXN', descripcion:'Pesos mexicanos'},
    {id: 2, codigo:'USD', descripcion:'Dólares americanos'},
    {id: 3, codigo:'EUR', descripcion:'Euros'}
  ],
  init: function() {
    self = this;
    Promise.all([
      this.store.find('empleado'),
      this.store.find('proyecto'),
      this.store.find('sede'),
      this.store.find('cliente'),
      this.store.find('contacto')
    ]).then(function(values){
      self.set('empleadosCache', values[0]);
      self.set('proyectosCache', values[1]);
      self.set('sedesCache', values[2]);
      self.set('clientes', values[3]);
      self.set('contactos', values[4]);
       return values;
    });
    console.log('App Init');
  },
  closeNotification: function() {
    this.set('notification', null);
    this.set('notification_type', null);
  },

  notify: function(notification, notification_type) {
    notification_type = typeof notification_type !== 'undefined' ? notification_type : 'alert-success';
    this.set('notification_type', notification_type);
    this.set('notification', notification);
  }
});
