App.ServicioController = Ember.ObjectController.extend({
  needs: ["application", "solicitud", "servicios", "cotizacion"],

  servicio_datos: function() {
    servicio = this.get('model');

    var res = {
      titulo: servicio.get('nombre'),
      muestras: []
    };

    var costeos = servicio.get('costeos');
    var total = 0;
    var subtotal = 0;
    servicio.get('muestras').forEach(function(m) {
      muestra = m;
      muestra.set('costeos', []);
      costeos.forEach(function(c) {
        if (c.get('muestra.id') == m.get('id') && (c.get('servicio.id') == servicio.get('id'))) {
          total = 0;
          c.get('costeo_detalle').forEach(function(d) {
            subtotal = d.get('cantidad') * d.get('precio_unitario');
            total += subtotal;
          });
          c.total = total;
          muestra.costeos.push(c);
        }
      });
      res.muestras.push(muestra);
    });

    return res;

  }.property('model.muestras_string'),

  showServicio: true,

  isInicial: function() {
    return this.get('model.status') == this.get('controllers.servicios.Status.inicial');
  }.property('model.status'),

  isEsperandoCosteo: function() {
    return this.get('model.status') == this.get('controllers.servicios.Status.esperando_costeo');
  }.property('model.status'),

  isEsperandoArranque: function() {
    return this.get('model.status') == this.get('controllers.servicios.Status.esperando_arranque');
  }.property('model.status'),

  isCotizacionAceptada: function() {
    var solicitud = this.get('controllers.solicitud');
    var result = solicitud.get('model.lastCotizacion.status') == this.get('controllers.cotizacion.Status.aceptado');
    return result;
  }.property('model.status'),

  isNotReadyForSave: function () {
    var result = this.get('content.isDirty') == true && this.get('content.isValid') == true;
    return !result;
  }.property('content.isDirty', 'content.isValid'),

  canEdit: function () {
    var solicitud = this.get('controllers.solicitud');
    return this.get('model.status') == 1 && solicitud.get('model.status')!=solicitud.get('model.Status.cancelada');
  }.property('model.status'),

  actions: {
    solicitaCosteo: function() {
      servicio = this.get('model');
      var self = this

      url = '/vinculacion/servicios/' + servicio.get('id') + '/solicitar_costeo';

      $.post(url).then(function(response) {
        if (!response.error) {
          self.get('controllers.application').notify('Se solicito costeo');
          servicio.set('status', response.servicio.status); 
          // XXX: En teoria no lo guardamos ya porque ya lo hizo /solicitar_costeo
          //servicio.save();
        } else {
          console.log('ERROR');
          console.log(response);
          self.get('controllers.application').notify('Error al solicitar costeo', 'alert-danger');  
        }
      });
   
    }
  }
});
