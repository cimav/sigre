App.ServiciosNewController = Ember.ObjectController.extend({
  needs: ["application", "solicitud", "servicios"],
  isNotDirty: Ember.computed.not('content.isDirty'),

  servicioBitacoraTipoII: null,
  muestraTipoII: null,

  actions: {
    submit: function() {
      var self = this;
      var solicitud = self.get('controllers.solicitud');
      var servicio = self.get('model');

      var onSuccess = function(servicio) {

        if (self.get('isTipoII')) {
          self.postSaveTipoII(solicitud, servicio);
        }

        self.transitionToRoute('servicio', servicio);
        self.get('controllers.application').notify('Se agregó nuevo servicio');
      };

      var onFail = function(servicio) {
        self.get('controllers.application').notify('Error al agregar servicio', 'alert-danger');
      };

      if (self.get('isTipoIII')) {
        if (Ember.isEmpty(self.get('nombre'))) {
          alert("Requiere capturar nombre del servicio");
          return;
        }
      }
      if (self.get('isTipoII')) {

        if (Ember.isEmpty(self.muestraTipoII)) {
          alert("Requiere capturar muestra");
          return;
        }
        if (Ember.isEmpty(self.servicioBitacoraTipoII)) {
          alert("Requiere capturar servicio");
          return;
        }

        self.preSaveTipoII(servicio);
      } else {
        servicio.set('status', self.get('controllers.servicios.Status.inicial')); //requerido debido al servicio_params en servicios_controller.rb
      }

      solicitud.get('model').get('servicios').pushObject(servicio);
      servicio.save().then(onSuccess, onFail);
    }
  },

  preSaveTipoII: function(servicio) {
    var self = this;

    // asignar la muestra como unica del servicio
    var muestras = [self.muestraTipoII];
    servicio.set('muestras', muestras);
    var selected_muestras = muestras.map(function(el) { return el.id}).toArray().join();
    servicio.set('muestras_string', selected_muestras);

    // servicio: le asigna los valores del servicioBitacora capturado
    var srvStatusEsperandoArranque = self.get('controllers.servicios.Status.esperando_arranque');
    servicio.set('status', srvStatusEsperandoArranque);
    servicio.set('servicio_bitacora', self.servicioBitacoraTipoII);
    servicio.set('nombre', self.servicioBitacoraTipoII.get('nombre'));
    servicio.set('descripcion', self.servicioBitacoraTipoII.get('descripcion'));
    servicio.set('empleado', self.servicioBitacoraTipoII.get('empleado'));

  },

  postSaveTipoII: function(solicitud, servicio) {

    var self = this;

    // optiene la ultima cotizacion
    var lastCotizacion = solicitud.get('cotizaciones').get('lastObject');
    if (lastCotizacion != null) {

      // copiar tiempo_entrega
      lastCotizacion.set('tiempo_entrega', solicitud.get('tiempo_entrega'));

      // obtener detalle correspondiente al servicio
      var detalle = lastCotizacion.get('cotizacion_detalles').findBy('servicio_id', Number(servicio.get('id')));
      if (detalle === undefined || detalle === null) {
        // si no existe crearlo
        detalle = self.store.createRecord('cotizacion_detalle');
        // agregarlo a la cotizacion
        lastCotizacion.get('cotizacion_detalles').pushObject(detalle);
        // asignarle al servicio al que apunta
        detalle.set('servicio_id', servicio.get('id'));
      }
      // asignarle valores de la muestra y el servicio
      detalle.set('inmutable', true);
      detalle.set('cantidad',  self.muestraTipoII.get('cantidad'));
      detalle.set('concepto', servicio.get('nombre'));
      detalle.set('cotizacion', lastCotizacion); // asignarle la cotización
      // precio depende del tiempo_entrega
      var precio_venta = solicitud.get('tiempo_entrega') * servicio.get('servicio_bitacora').get('precio_venta');
      detalle.set('precio_unitario', precio_venta);

      // persistir detalle
      detalle.save();
      // persitir cotizacion
      lastCotizacion.save();
      // No requiere re-persistir solicitud
    }

  },

 isTipoIII: function() {
    var result = this.get('controllers.solicitud.tipo') == 3;
    return result;
  }.property('controllers.solicitud.tipo'),

  isTipoII: function() {
    var result = this.get('controllers.solicitud.tipo') == 2;
    return result;
  }.property('controllers.solicitud.tipo')


});

App.NewChildController = Ember.ObjectController.extend({    
  selected: function() {
    var muestra = this.get('content');
    var muestras = this.get('parentController.muestras');
    return muestras.contains(muestra);
  }.property(),
  selectedChanged: function() {
    var muestra = this.get('content');
    var servicio = this.get('parentController').get('model');
    var muestras = this.get('parentController.muestras');
    if (this.get('selected')) {                                    
      muestras.pushObject(muestra);          
    } else {                                    
      muestras.removeObject(muestra);
    }        
    var selected_muestras = muestras.map(function(el) { return el.id}).toArray().join();
    servicio.set('muestras_string', selected_muestras);
  }.observes('selected') 
});