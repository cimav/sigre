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

      // El Cliente pone todos los servicos En_proceso,
      // Y el Server pone la solicitud En_Proceso.
      var solicitud = this.get('model');
      var servicios = solicitud.get('servicios');
      var srvStatusEnProceso = this.get('controllers.servicios.Status.en_proceso');

      servicios.forEach(function (servicio, index, enumerable) {
        servicio.set('solicitud', solicitud); // se requiere debido a que el serializer no tiene el solicitud_id
        servicio.set('status', srvStatusEnProceso);
        servicio.save();
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

  isCotizacionAceptada: function() {
    var result = this.get('model.lastCotizacion.status') == this.get('controllers.cotizacion.Status.aceptado');
    console.log(this.get('model.lastCotizacion.status')+ ' == ' + this.get('controllers.cotizacion.Status.aceptado'));
    if (result) {
      this.set('colorAceptada', this.get('colorChecked'));
    } else {
      this.set('colorAceptada', this.get('colorUnchecked'));
    }
    return result;
  }.property('model.status'), // observa el status de la Solicitud, pero compara con el status de la ultima cotizacion

  observesAutoChecked: function() {
    // cuando la solicitud esta enProceso o finaliza,
    // 'palomear' los puntos automaticos (notificaciones y resguardos)
    var enProceso = this.get('model.Status.en_proceso');
    var finalizada = this.get('model.Status.finalizada');
    var statusSol = this.get('model.status');
    result = statusSol == enProceso || statusSol == finalizada;
    console.log('XXX66: ' + result);
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
      console.log('XXX44: ' + statusSrv);
      return statusSrv == esperandoArranque || statusSrv == enProceso || statusSrv == finalizado;
    });
    console.log('XXX55: ' + result);

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
  }.observes('colorServicios').property('colorServicios')

});