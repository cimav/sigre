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
  tamanos_empresa: [
    {id: 1, descripcion: "Micro"},
    {id: 2, descripcion: "Pequeña"},
    {id: 3, descripcion: "Mediana"},
    {id: 4, descripcion: "Grande"}
  ],
  sectores_empresa: [
    {id: 1, descripcion: "Maquiladoras"},
    {id: 2, descripcion: "Servicios"},
    {id: 3, descripcion: "Público e institucional"}
  ],

  init: function() {
    self = this;
    Promise.all([
      this.store.find('empleado'),
      this.store.find('proyecto'),
      this.store.find('sede'),
      this.store.find('cliente'),
      this.store.find('contacto'),
      this.store.find('pais'),
      this.store.find('estado'),
      this.store.find('servicio_bitacora')
    ]).then(function(values){
      self.set('empleadosCache', values[0]);
      self.set('proyectosCache', values[1]);
      self.set('sedesCache', values[2]);
      self.set('clientes', values[3]);
      self.set('contactos', values[4]);
      self.set('paises', values[5]);
      self.set('estados', values[6]);
      self.set('servicios_bitacora', values[7]);
      return values;
    }, function(reason){
      console.log('Promises fail: ' + reason);
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
