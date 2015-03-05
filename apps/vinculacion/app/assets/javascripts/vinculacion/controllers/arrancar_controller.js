App.ArrancarController = Ember.ObjectController.extend({
  needs: ['application','servicios', 'cotizacion'],

  colorChecked: '#47a447',
  colorUnchecked: 'lightgray',
  colorAutoChecked: '#E6B45E', //'$muestra-codigo-border',

  colorAceptada: 'ffffff',
  colorOrdenCompra: 'ffffff',
  colorFechas: 'ffffff',
  colorAuto: 'ffffff',
  colorServicios: 'ffffff',

  actions: {
    update: function() {
      solicitud = this.get('model');
      self = this;
      var onSuccess = function(solicitud) {
        self.get('controllers.application').notify('Se actualizó check-list');
      };
      var onFail = function(solicitud) {
        self.get('controllers.application').notify('Error al actualizar check-list', 'alert-danger');
      };
      solicitud.save().then(onSuccess, onFail);
    },

    arrancar: function() {

      var solicitud = this.get('model');
      var servicios = solicitud.get('servicios');
      var srvStatusEnProceso = this.get('controllers.servicios.Status.en_proceso');

      // poner todos los servicios en_proceso
      servicios.forEach(function (servicio, index, enumerable) {
        servicio.set('solicitud', solicitud); // se requiere debido a que el serializer no tiene el solicitud_id
        servicio.set('status', srvStatusEnProceso);
        servicio.save();
      });

      // En rails. Si todos los servicios estan en_proceso, en automatico pone la solicitud en_proceso
      // a excepción de cuando no tiene servicios. Por eso poner la solicitud en_proceso explicitamente.
      solicitud.set('status', this.get('model.Status.en_proceso'));
      solicitud.save();

      // Notificar el arranque a la Bitacora publicando el resque bus.
      this.send('notificar_arranque', solicitud);

    },

    notificar_arranque: function(solicitud) {
      // notificar el arranque a bitacora a través del request bus
      self = this;
      if (solicitud.get('tipo') == 1) {
        url = '/vinculacion/solicitudes/' + self.get('id') + '/notificar_arranque_no_coordinado'; // url del controlador en rails
      } else {
        url = '/vinculacion/solicitudes/' + self.get('id') + '/notificar_arranque'; // url del controlador en rails
      }
      $.post(url).then(function(response) {
        if (!response.error) {
          self.get('controllers.application').notify('Se notificó arranque a Bitácora');
          self.transitionToRoute('solicitud', solicitud);
        } else {
          console.log('ERROR');
          console.log(response);
          self.get('controllers.application').notify('Error al arrancar solicitud', 'alert-danger');
        }
      });
    }

  },

  isNotReadyForSave: function () {
    var isDirty = this.get('content.isDirty');
    var isDuracionValida = this.get('isDuracionValida');
    result = isDirty && isDuracionValida;
    return !result;
  }.property('content.isDirty', 'model.duracion'),

  isNotReadyForArrancar: function () {
    var isNotDirty = this.get('content.isDirty') == false;
    var isCotizaAceptada = this.get('isCotizacionAceptada');
    var hasOrdenCompra = this.get('hasOrdenCompra');
    var hasAllServicios = this.get('isAllServiciosReady');
    var isDuracionValida = this.get('isDuracionValida');
    result = isNotDirty && isDuracionValida && hasOrdenCompra && isCotizaAceptada && hasAllServicios;
    return !result;
  }.property('content.isDirty', 'model.duracion', 'model.orden_compra', 'model.isAceptada'),

  isNotEnabledToEdit: function() {
    // No puede editar si la solicitud esta en enProceso, finaliza o cancelada.
    var enProceso = this.get('model.Status.en_proceso');
    var finalizada = this.get('model.Status.finalizada');
    var cancelada = this.get('model.Status.cancelada');
    var statusSol = this.get('model.status');
    result = statusSol == enProceso || statusSol == finalizada || statusSol == cancelada;
    return result;
  }.property('model.status'),

  isReadyToDownPDFPresupuesto: function() {
    var enProceso = this.get('model.Status.en_proceso');
    var finalizada = this.get('model.Status.finalizada');
    var statusSol = this.get('model.status');
    result = statusSol == enProceso || statusSol == finalizada;
    return !result;
  }.property('model.status'),

  // Hack: las funciones declaradas como properties no son llamadas hasta que se use el set o get.
  // El cambio de instancia no usa los get y set de las propiedades.
  // Por tanto, al entrar al Controller no son llamadas.
  // Se requiere llamar el get de cada propiedad a usar para poner los check.
  // No funciona pornerlas en el init porque las propiedades van vacias en ese punto.
  // Tampoco funciona ponerlas como observes().property()
  // El observes('status') también se llama cuando cambia la instancia  y no solo con el el get/set directo.
  checkPropertiesHack: function() {
    // al cargar la instancia, forza a llamar a las funciones property.
    Ember.run.once(this, function() {
      // que lo llame solo una vez
      this.get('hasOrdenCompra')
      this.get('isCotizacionAceptada');
      this.get('isAllServiciosReady');
      this.get('isDuracionValida');
    });
  }.observes('model.status'),

  isCotizacionAceptada: function() {
    var result = this.get('model.lastCotizacion.status') == this.get('controllers.cotizacion.Status.aceptado');
    if (result) {
      this.set('colorAceptada', this.get('colorChecked'));
    } else {
      this.set('colorAceptada', this.get('colorUnchecked'));
    }
    return result;
  }.property('model.status'), // observa el status de la Solicitud, pero compara con el status de la ultima cotizacion

  isAutoChecked: function() {
    // cuando la solicitud esta enProceso o finaliza,
    // 'palomear' los puntos automaticos (notificaciones y resguardos)
    var enProceso = this.get('model.Status.en_proceso');
    var finalizada = this.get('model.Status.finalizada');
    var statusSol = this.get('model.status');
    result = statusSol == enProceso || statusSol == finalizada;
    if (result) {
      this.set('colorAuto', this.get('colorChecked'));
    } else {
      this.set('colorAuto', this.get('colorAutoChecked'));
    }
    return result;
  }.observes('model.status'),

  hasOrdenCompra: function() {
    var oc = this.get('model.orden_compra');
    oc = !oc ? "" : oc.trim();
    result = oc.length > 0;
    if (result) {
      this.set('colorOrdenCompra', this.get('colorChecked'));
    } else {
      this.set('colorOrdenCompra', this.get('colorUnchecked'));
    }
    return result;
  }.property('model.orden_compra'),

  isAllServiciosReady: function() {
    // Ready significa que el servicio esta en status: esperando_arranque, en_proceso o finalizado.
    // Todos los servicios deben estar en Ready para arrancar
    var esperandoArranque = this.get('controllers.servicios.Status.esperando_arranque');
    var enProceso = this.get('controllers.servicios.Status.en_proceso');
    var finalizado = this.get('controllers.servicios.Status.finalizado');

    var result = this.get('model.servicios').every(function (servicio) {
      var statusSrv = servicio.get('status');
      return statusSrv == esperandoArranque || statusSrv == enProceso || statusSrv == finalizado;
    });

    if (result) {
      this.set('colorServicios', this.get('colorChecked'));
    } else {
      this.set('colorServicios', this.get('colorUnchecked'));
    }
    return result;
  }.property('model.status'),


  isDuracionValida: function() {
    // la duración debe ser mayor a 0
    var duracion = this.get('model.duracion');
    result = !isNaN(duracion) && duracion > 0;
    if (result) {
      this.set('colorFechas', this.get('colorChecked'));
    } else {
      this.set('colorFechas', this.get('colorUnchecked'));
    }
    return result;
  }.property('model.duracion'),

  styleAceptada: function() {
    var str = 'color:%@%@'.fmt(this.get('colorAceptada'));
    return str;
  }.observes('colorAceptada').property('colorAceptada'),

  styleAuto: function() {
    var str = 'color:%@%@'.fmt(this.get('colorAuto'));
    return str;
  }.observes('colorAuto').property('colorAuto'),

  styleOrdenCompra: function() {
    var str = 'color:%@%@'.fmt(this.get('colorOrdenCompra'));
    return str;
  }.observes('colorOrdenCompra').property('colorOrdenCompra'),

  styleFechas: function() {
    var str = 'color:%@%@'.fmt(this.get('colorFechas'));
    return str;
  }.observes('colorFechas').property('colorFechas'),

  styleServicios: function() {
    var str = 'color:%@%@'.fmt(this.get('colorServicios'));
    return str;
  }.observes('colorServicios').property('colorServicios'),

  pdf_url: function(){
    return '/vinculacion/estimacion_costos/' + this.get('id');
  }.property('model.id'),

});
