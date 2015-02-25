App.SolicitudEditController = Ember.ObjectController.extend({
  needs: ['application', 'solicitudes', 'servicios'],
  isNotDirty: Ember.computed.not('content.isDirty'),
  newMuestra: null,
  servicioBitacora: null,

  actions: {

    submit: function () {
      solicitud = this.get('model');
      self = this;
      var noErrors = true;

      //TODO falta validar

      var onSuccess = function (solicitud) {

        // despues de guardar una nueva solicitud
        // recarga la lista de solicitud_busqueda
        self.get('controllers.solicitudes').send('reloadModel');

        self.transitionToRoute('solicitud', solicitud);
        self.get('controllers.application').notify('Se actualizó solicitud');

       };

      var onFail = function (solicitud) {
        self.get('controllers.application').notify('Error al actualizar solicitud', 'alert-danger');
        noErrors = false;
      };

      solicitud.save().then(onSuccess, onFail);

      if (noErrors && !solicitud.get('is_coordinado')) {
        // si no hubo errores y es Servicio No-Coordinado

        // salva la muestra
        var newMuestra = self.get('newMuestra');
        if (solicitud.get('muestras').get('length') == 0) {
          // si no habia sido capturada
          solicitud.get('muestras').pushObject(newMuestra);
        }
        newMuestra.save();

        // salva el servicio
        var servicioBitacora = solicitud.get('servicioBitacora');
        if (servicioBitacora == null) {
          servicioBitacora = this.get('controllers.Application.servicios_bitacora').get('firstObject');
          solicitud.set('servicioBitacora',servicioBitacora);
        }
        var servicio = solicitud.get('servicios').get('firstObject');
        if (servicio == null) {
          // insertion -- esto debería ocurrir sólo cuando es nueva solicitud (la 1era vez que se edita)
          servicio = self.store.createRecord('servicio');
          var srvStatusEsperandoArranque = this.get('controllers.servicios.Status.esperando_arranque');
          servicio.set('status', srvStatusEsperandoArranque);
          servicio.set('servicio_bitacora', servicioBitacora);
          servicio.set('nombre', servicioBitacora.get('nombre'));
          servicio.set('descripcion', servicioBitacora.get('descripcion'));
          servicio.set('empleado', servicioBitacora.get('empleado'));
          solicitud.get('servicios').pushObject(servicio);
          servicio.save();

          // la 1era vez, le inyecta el servicio a la cotizacion como concepto
          var cotizacion = solicitud.get('cotizaciones').get('firstObject');
          if (cotizacion != null) {
            // no debería tener detalle
            var cotizacion_detalle = self.store.createRecord('cotizacion_detalle');
            cotizacion_detalle.set('cantidad', newMuestra.get('cantidad'));
            cotizacion_detalle.set('concepto', servicio.get('nombre'));
            cotizacion_detalle.set('precio_unitario', servicioBitacora.get('precio_venta'));
            // empuja detalle a cotizaciones
            cotizacion.get('cotizacion_detalles').pushObject(cotizacion_detalle);
            cotizacion_detalle.set('cotizacion', cotizacion); // seguridad
            cotizacion_detalle.save();

            Ember.run.later(function(){
              // para que muestre el detalle en la cotización
              solicitud.reload();
            }, 1000);
          }

        } else if (servicio.get('servicio_bitacora') != servicioBitacora) {
          // update
          servicio.set('solicitud', solicitud); // <-- requerido
          servicio.set('servicio_bitacora', servicioBitacora);
          servicio.set('nombre', servicioBitacora.get('nombre'));
          servicio.set('descripcion', servicioBitacora.get('descripcion'));
          servicio.set('empleado', servicioBitacora.get('empleado'));
          servicio.save();
        }

      }

    }
  },

  newMuestraChanged: function() {
    // cualquier cambio en la muestra, pone Dirty a la solicitud
    if (this.get('model') != null) {
      // TODO no funciona del todo bien
      this.get('model').send('becomeDirty');
    }
  }.observes('newMuestra.identificacion', 'newMuestra.cantidad', 'newMuestra.descripcion').on('init'),

  servicioBitacoraChanged: function() {
    // cualquier cambio en el servicio, pone Dirty a la solicitud
    if (this.get('model') != null) {
      // TODO no funciona del todo bien
      this.get('model').send('becomeDirty');

      // asigna el servicioBitacora del controllador al modelo
      this.get('model').set('servicioBitacora', this.get('servicioBitacora'));

    }
  }.observes('servicioBitacora').on('init')


});

