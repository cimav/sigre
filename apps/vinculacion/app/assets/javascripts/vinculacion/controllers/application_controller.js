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
      //this.store.find('contacto'),
      this.store.find('pais'),
      this.store.find('estado'),
      this.store.find('servicio_bitacora'),
      this.store.find('laboratorio_bitacora')
    ]).then(function(values){
      self.set('empleadosCache', values[0]);
      self.set('proyectosCache', values[1]);
      self.set('sedesCache', values[2]);
      self.set('clientes', values[3]);
      //self.set('contactos', values[4]);
      self.set('paises', values[4]);
      self.set('estados', values[5]);
      self.set('servicios_bitacora', values[6]);
      self.set('laboratorios_bitacora', values[7]);
    

      /* armar data para options de Servicios_Bitacora */
      var serviciosBitacoraOptions = Ember.A();
      values[2].forEach(function(sede) {
        var servicios = Ember.A();
        sede.get('servicios_bitacora').forEach(function(srv) {
          var abr = srv.get('sede').get('id') == 1 ? 'CHI' : 'MTY';
          var child = {
            id: srv,
            text: srv.get('nombre'),
            description: abr
          };
          servicios.push(child);
        });
        var parent = {
          text: sede.get('nombre'),
          children: servicios
        };
        serviciosBitacoraOptions.push(parent)
      });
      self.set('serviciosBitacoraOptions', serviciosBitacoraOptions);

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
  },

  actions: {
    agregar_contacto: function() {
      var self = this;
      var rutaSolicitud = self.currentRouteName; // "solicitudes.new" o "solicitud.edit"
      var solicitud = self.controllerFor(rutaSolicitud).get('model');
      var cliente = solicitud.get('cliente');
      var new_contacto = self.store.createRecord('contacto', {
        nombre: self.get('nombre'),
        telefono: self.get('telefono'),
        email: self.get('email'),
        cliente: cliente // al definirle cliente, no requiere push
      });
      new_contacto.save();
      solicitud.set('contacto', new_contacto); // seleccionarlo
      // TODO refresh la seleccion del select2view

      // clear data
      self.set('nombre', '');
      self.set('telefono', '');
      self.set('email', '');

    }

  }

});
