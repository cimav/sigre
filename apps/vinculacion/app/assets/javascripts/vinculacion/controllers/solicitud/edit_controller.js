App.SolicitudEditController = Ember.ObjectController.extend({
  needs: ['application', 'solicitudes', 'servicios'],
  isNotDirty: Ember.computed.not('content.isDirty'),
  newMuestra: null,
  servicioBitacoraSeleccion: null,

  actions: {

    submit: function () {
      var solicitud = this.get('model');
      var self = this;
      var validation_errors = [];

      var onSuccess = function (solicitud) {

        if (solicitud.get('tipo') == 1) {
          // después de persitir la solicitud, ajustar la muestra, el servicios y los detalles de la cotización
          self.postSaveTipoI(solicitud);
        }

        self.transitionToRoute('solicitud', solicitud);
        self.get('controllers.application').notify('Se actualizó solicitud');
      };

      var onFail = function (solicitud) {
        self.get('controllers.application').notify('Error al actualizar solicitud', 'alert-danger');
      };

      if (solicitud.get('tipo') == 1) {
        // get muestra
        var newMuestra = self.get('newMuestra');

        if ((newMuestra.get('identificacion') === null) || (newMuestra.get('identificacion') === undefined) || (newMuestra.get('identificacion').trim() == '')) {
          validation_errors.push('Se debe especificar la identificación de la muestra');
        }
        if ((newMuestra.get('cantidad') === null) || (newMuestra.get('cantidad') === undefined) || (newMuestra.get('cantidad') <= 0)) {
          validation_errors.push('Se debe especificar una cantidad mayor que 0');
        }
      }

      if (validation_errors.length > 0) {
        var error_msg = "Existen errores:\n"
        validation_errors.forEach(function(e) {
          error_msg += e + "\n";
        });
        alert(error_msg);
        return;
      }

      // Guardar solicitud
      solicitud.save().then(onSuccess, onFail);

    }
  },

  postSaveTipoI: function (solicitud) {
    var self = this;

    // No requieres tumbar la muestra ????
//    // agrega la muestra a la solicitud que solo debe tener una muestra
//    solicitud.get('muestras').forEach(function (mst) {
//      //solicitud.get('muestras').removeObject(muestra);
//      //mst.destroyRecord();
//    });

    // salva la muestra capturada (nueva o editada)
    var newMuestra = self.get('newMuestra');
    solicitud.get('muestras').pushObject(newMuestra);
    newMuestra.save();

    // servicioBitacora
    var servicioBitacoraCapturado = solicitud.get('servicioBitacora');
    if (servicioBitacoraCapturado == null) {
      // se asegura tener un servicioBitacora capturado
      servicioBitacoraCapturado = this.get('controllers.Application.servicios_bitacora').get('firstObject');
      solicitud.set('servicioBitacora', servicioBitacoraCapturado);
    }

    // recupera el servicio de la solicitud (corresponde al 1er servicio de la collection)
    var firstServicio = solicitud.get('servicios').get('firstObject'); // debería ser un solo servicio
    if (firstServicio === undefined || firstServicio === null) {
      // si aun no existe, lo crea
      firstServicio = self.store.createRecord('servicio');
      // y lo agrega a la solicitud
      solicitud.get('servicios').pushObject(firstServicio);
    }
    // le asigna los valores del servicioBitacora capturado
    var srvStatusEsperandoArranque = this.get('controllers.servicios.Status.esperando_arranque');
    firstServicio.set('status', srvStatusEsperandoArranque);
    firstServicio.set('servicio_bitacora', servicioBitacoraCapturado);
    firstServicio.set('nombre', servicioBitacoraCapturado.get('nombre'));
    firstServicio.set('descripcion', servicioBitacoraCapturado.get('descripcion'));
    firstServicio.set('empleado', servicioBitacoraCapturado.get('empleado'));

    // lo persiste (create o update)
    firstServicio.save();

    // optiene la ultima cotizacion
    var lastCotizacion = solicitud.get('cotizaciones').get('lastObject');
    if (lastCotizacion != null) {

      // copiar tiempo_entrega
      lastCotizacion.set('tiempo_entrega', solicitud.get('tiempo_entrega'));

      // obtener el 1er detalle (corresponde al servicio)
      var firstDetalle = lastCotizacion.get('cotizacion_detalles').get('firstObject');
      if (firstDetalle === undefined || firstDetalle === null) {
        // si no existe crearlo
        firstDetalle = self.store.createRecord('cotizacion_detalle');
        lastCotizacion.get('cotizacion_detalles').pushObject(firstDetalle);
      }
      // asignarle valores de la muestra y el servicio
      firstDetalle.set('inmutable', true);
      firstDetalle.set('cantidad', newMuestra.get('cantidad'));
      firstDetalle.set('concepto', firstServicio.get('nombre'));
      firstDetalle.set('cotizacion', lastCotizacion); // asignarle la cotización
      // precio depende del tiempo_entrega
      var precio_venta = solicitud.get('tiempo_entrega') * servicioBitacoraCapturado.get('precio_venta');
      firstDetalle.set('precio_unitario', precio_venta);

      // persistir detalle
      firstDetalle.save();
      // persitir cotizacion
      lastCotizacion.save();
      // No requiere re-persistir solicitud
    }

    Ember.run.later(function () {
      // para que muestre el detalle en la cotización
      solicitud.reload();
      // recarga la lista de solicitud_busqueda
      self.get('controllers.solicitudes').send('reloadModel');
    }, 1000);

  },

  newMuestraChanged: function() {
    // cualquier cambio en la muestra, pone Dirty a la solicitud
    if (this.get('model') != null) {
      // TODO no funciona del todo bien
      this.get('model').send('becomeDirty');
    }
  }.observes('newMuestra.identificacion', 'newMuestra.cantidad', 'newMuestra.descripcion').on('init'),

  /*
  servicioBitacoraChanged: function() {
    // cualquier cambio en el servicio, pone Dirty a la solicitud
    var solicitud = this.get('model');
    if (solicitud != null) {
      // TODO no funciona del todo bien
      solicitud.send('becomeDirty');

      // asigna el servicioBitacora del controllador al modelo
      solicitud.set('servicioBitacora', this.servicioBitacoraSeleccion);

    }
  }.observes('servicioBitacoraSeleccion').on('init'),
*/

  servicioBitacoraSeleccionChanged: function() {
    // asigna el servicioBitacora del controllador al modelo
    this.get('model').set('servicioBitacora', this.servicioBitacoraSeleccion);
  }.observes('servicioBitacoraSeleccion')



});

