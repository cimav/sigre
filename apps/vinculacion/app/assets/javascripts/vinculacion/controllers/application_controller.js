App.ApplicationController = Ember.Controller.extend({
  prioridades: [
    {id: 1, descripcion: "Baja"},
    {id: 2, descripcion: "Media"},
    {id: 3, descripcion: "Alta"}
  ],
  condicionesPagoCache: [{id:'1', codigo:'Contado', descripcion:''}, [{id:'2', codigo:'Parcial', descripcion:''}], [{id:'3', codigo:'8 días', descripcion:''}], [{id:'4', codigo:'15 días', descripcion:''}]],
  idiomasCache: [{id:'1', codigo:'ES', descripcion:'Español'}, [{id:'2', codigo:'IN', descripcion:'Inglés'}]],
  divisasCache: [{id:'1', codigo:'MXN', descripcion:'Pesos mexicanos'}, {id:'2', codigo:'USD', descripcion:'Dolares americanos'}, {id:'3', codigo:'EUR', descripcion:'Euros'}],
  init: function() {
    self = this;
    Promise.all([
      this.store.find('empleado'),
      this.store.find('proyecto')
    ]).then(function(values){
       self.set('empleadosCache', values[0]);
       self.set('proyectosCache', values[1]);
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
