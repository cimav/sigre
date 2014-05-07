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
      console.log('Reload...'); 
      self.get('controller.model').reload(); 
      self.reloadSolicitud();
    }, 10000);
  },


});