App.ApplicationController = Ember.Controller.extend({
  prioridadesCache: [{descripcion: "Baja", id: 1},{descripcion: "Media", id: 2},{descripcion: "Alta", id: 3}],
  closeNotification: function() {
    this.set('notification', null);
    this.set('notification_type', null);
  },

  notify: function(notification, notification_type) {
    notification_type = typeof notification_type !== 'undefined' ? notification_type : 'alert-success';
    this.set('notification_type', notification_type);
    this.set('notification', notification);
  }
});
