App.SolicitudRoute = Ember.Route.extend({
  
  poll: null,

  activate: function() {
    this.controllerFor('solicitudes').set('showSolicitudesList', false);
    console.log('Poll Solicitud');
    this.reloadSolicitud();
  },

  deactivate: function() {
    this.controllerFor('solicitudes').set('showSolicitudesList', true);
    Ember.run.cancel(this.poll);
  },

  reloadSolicitud: function() {
    var self = this;
    this.poll = Ember.run.later(function() {
      console.log('Verificar estado de solicitud...'); 
      id = self.get('controller.model.id');
      status_client = self.get('controller.model.status');
      jQuery.getJSON("/vinculacion/solicitudes/" + id + "/estado_actual", function(status_server) {
        if (status_client != status_server) {
          console.log('Recargar solicitud', status_client, status_server);
          self.get('controller.model').reload(); 
        }
      });
      self.reloadSolicitud();
    }, 10000);
  },


});