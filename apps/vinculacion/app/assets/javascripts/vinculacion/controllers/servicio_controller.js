App.ServicioController = Ember.ObjectController.extend({
  needs: ["application", "solicitud", "servicios", "cotizacion"],

  solo_codigo: function() {
    var codigo = this.get('model.codigo') + "";
    var solicitud = this.get('controllers.solicitud');
    
    return codigo.replace(solicitud.get("codigo") + "-", "");
  }.property('model.codigo'),

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
          c.set('total', total);
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

  isCancelado: function() {
    return this.get('model.status') == this.get('controllers.servicios.Status.cancelado');
  }.property('model.status'),

  isNotReadyForSave: function () {
    var result = this.get('content.isDirty') == true && this.get('content.isValid') == true;
    return !result;
  }.property('content.isDirty', 'content.isValid'),

  canEdit: function () {
    var solicitud = this.get('controllers.solicitud');
    if (solicitud.get('tipo') == 2) {
      return this.get('model.status') <= 3 && solicitud.get('model.status') != solicitud.get('model.Status.cancelada');
    } else {
      return this.get('model.status') == 1 && solicitud.get('model.status') != solicitud.get('model.Status.cancelada');
    }
  }.property('model.status'),

  canCancel: function () {
    // Solo se puede cancelar antes de arrancar.
    var solicitud = this.get('controllers.solicitud');
    return this.get('model.status') <= 3 && 
           solicitud.get('model.status') != solicitud.get('model.Status.cancelada');    
  }.property('model.status'),

  actions: {
    cancelar: function(s) {
      if (confirm("¿Desea cancelar el servicio " + s.get('consecutivo') + "?")) {
        var self = this;
        var solicitud = self.get('controllers.solicitud');

        url = '/vinculacion/servicios/' + s.id + '/cancelar';

        $.post(url).then(function(response) {
          if (!response.error) {

            self.get('controllers.application').notify('Se cancelo el servicio');
            s.set('status', response.servicio.status); 

            if (solicitud.get('tipo') == 2) {
              self.postCancelTipoII(solicitud, s);
            }

            // XXX: En teoria no lo guardamos ya porque ya lo hizo /cancelar
            //servicio.save();
          } else {
            console.log('ERROR');
            console.log(response);
            self.get('controllers.application').notify('Error al solicitar costeo', 'alert-danger');  
          }
        });
      }
    },
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
  },

  postCancelTipoII: function(solicitud, servicio) {

    var self = this;
    // optiene la ultima cotizacion
    var lastCotizacion = solicitud.get('cotizaciones').get('lastObject');
    if (lastCotizacion != null) {

      // copiar tiempo_entrega
      lastCotizacion.set('tiempo_entrega', solicitud.get('tiempo_entrega'));

      // obtener detalle correspondiente al servicio
      var detalle = lastCotizacion.get('cotizacion_detalles').findBy('servicio_id', Number(servicio.get('id')));
      detalle.deleteRecord();
      detalle.save();
      lastCotizacion.save();
      // No requiere re-persistir solicitud
    }

  },
});
