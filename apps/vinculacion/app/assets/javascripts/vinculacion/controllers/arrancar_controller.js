App.ArrancarController = Ember.ObjectController.extend({
  needs: ['application','servicios'],

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
      solicitud = this.get('model');
      self = this;
      var onSuccess = function(solicitud) {
        self.get('controllers.application').notify('Se arrancó el servicio');
      };
      var onFail = function(solicitud) {
        self.get('controllers.application').notify('Error al arrancar el servicio', 'alert-danger');
      };
      solicitud.set('status', this.get('model.Status.en_proceso'));
      solicitud.save().then(onSuccess, onFail);
    }
  },

  isNotReadyForSave: function () {
    var result = this.get('content.isDirty') == true;
    result = result && this.get('isDuracionValida');
    return !result;
  }.property('content.isDirty', 'model.duracion'),

  isNotReadyForArrancar: function () {
    var isNotDirty = this.get('content.isDirty') == false;
    var hasOrdenCompra = this.get('hasOrdenCompra');
    var isDuracionValida = this.get('isDuracionValida');
    var isAceptada = this.get('model.isAceptada');
    var hasAllServiciosCosteados = this.get('hasAllServiciosCosteados');
    result = isNotDirty && isDuracionValida && hasOrdenCompra && isAceptada && hasAllServiciosCosteados;
    return !result;
  }.property('content.isDirty', 'model.duracion', 'model.orden_compra', 'model.isAceptada'),

  isSolicitudAceptada: function() {
    result = this.get('model.isAceptada');
    if (result) {
      this.set('colorAceptada', this.get('colorChecked'));
    } else {
      this.set('colorAceptada', this.get('colorUnchecked'));
    }
    return result;
  }.observes('model.isAceptada'),

  isSolicitudEnProceso: function() {
    result = this.get('model.isEnProceso');
    if (result) {
      this.set('colorAuto', this.get('colorChecked'));
    } else {
      this.set('colorAuto', this.get('colorAutoChecked'));
    }
    return result;
  }.observes('model.isEnProceso'),

  isDuracionValida: function() {
    var dur = this.get('model.duracion');
    result = !isNaN(dur) && dur > 0;
    if (result) {
      this.set('colorFechas', this.get('colorChecked'));
    } else {
      this.set('colorFechas', this.get('colorUnchecked'));
    }
    return result;
  }.property('model.duracion'),

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

  hasAllServiciosCosteados: function() {
    var result = true;
    var servicios = this.get('model.servicios').toArray();
    for(var i=0; i<servicios.length; i++) {
      if (servicios[i].get('status') != this.get('controllers.servicios.Status.esperando_arranque')) {
        result = false;
        break;
      }
    }
    if (result) {
      this.set('colorServicios', this.get('colorChecked'));
    } else {
      this.set('colorServicios', this.get('colorUnchecked'));
    }
    return result;
  }.property('model.status'),

  isNotEnabledToEdit: function() {
    return this.get('model.isEnProceso');
  }.property('model.isEnProceso'),

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