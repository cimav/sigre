App.ApplicationController = Ember.Controller.extend({
  init: function() {
    this.set('sedesCache',this.store.find('sede'));
    this.set('departamentosCache',this.store.find('departamento'));
    this.set('empleadosCache',this.store.find('empleado'));
  },

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