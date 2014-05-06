App.SolicitudView = Ember.View.extend({
  didInsertElement: function() {
    console.log('Poll Solicitudes');
    this.reloadSolicitud();
  },

  reloadSolicitud: function() {
    var self = this;
    Ember.run.later(function() {
      console.log('Reload...'); 
      self.get('controller.model').reload(); 
      self.reloadSolicitud();
    }, 10000);
  }

});