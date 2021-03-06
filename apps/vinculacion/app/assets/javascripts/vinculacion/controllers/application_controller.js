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
  proyectos: [
    {id: 20330, descripcion:'20330 Chihuahua', subproyecto: '00238'},
    {id: 20350, descripcion:'20350 Monterrey', subproyecto: '00001'},
    {id: 20409, descripcion:'20409 Durango',   subproyecto: '00002'}
  ],

  init: function() {
    self = this;
    Promise.all([
      this.store.find('pais'),
      this.store.find('estado'),
      this.store.find('sede'),
      this.store.find('proyecto'),
      this.store.find('empleado'),
      this.store.find('cliente'),      
      this.store.find('servicio_bitacora'),
      this.store.find('laboratorio_bitacora'),
      this.store.find('cliente_netmultix')
    ]).then(function(values){
      self.set('paises', values[0]);
      self.set('estados', values[1]);
      self.set('sedesCache', values[2]);
      self.set('proyectosCache', values[3]);
      self.set('empleadosCache', values[4]);
      self.set('clientes', values[5]);
      self.set('servicios_bitacora', values[6]);
      self.set('laboratorios_bitacora', values[7]);
      self.set('clientes_netmultix', values[8]);

      /* armar data para options de Servicios_Bitacora */
      var serviciosBitacoraOptions = Ember.A();
      values[2].forEach(function(sede) {
        var servicios = Ember.A();
        sede.get('servicios_bitacora').forEach(function(srv) {
          // var abr = srv.get('sede').get('id') == 1 ? 'CHI' : 'MTY';
          var abr = '---';
          if (srv.get('sede').get('id') == 1) {
            abr = 'CHI';
          } else if (srv.get('sede').get('id') == 2) {
            abr = 'MTY';
          } else if (srv.get('sede').get('id') == 3) {
            abr = 'CJZ';
          } else if (srv.get('sede').get('id') == 4) {
            abr = 'DGO';
          }
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


  // clientes: function() {
  //   return this.store.find('cliente');
  // }.property(),

  // empleadosCache: function() { 
  //   this.store.find('empleado');
  // }.property(),  
    

  // proyectosCache: function() {
  //   this.store.find('proyecto');
  // }.property(),
  // sedesCache: function() {  
  //   this.store.find('sede');
  // }.property(),
  // paises: function() {  
  //   this.store.find('pais');
  // }.property(),
  // estados: function() {  
  //   this.store.find('estado');
  // }.property(),
  // servicios_bitacora: function() {  
  //   this.store.find('servicio_bitacora');
  // }.property(),
  // laboratorios_bitacora: function() {  
  //   this.store.find('laboratorio_bitacora');
  // }.property(),
  // clientes_netmultix: function() {  
  //   this.store.find('cliente_netmultix');
  // }.property(),




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
