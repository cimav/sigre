App.CosteoProyectoController = Ember.ObjectController.extend({
  needs: ["application", "solicitud", "servicios"],

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
  },

});
