App.ApplicationController = Ember.Controller.extend({
  init: function() {
    self = this;
    Promise.all([
      this.store.find('sede'),
      this.store.find('departamento'),
      this.store.find('empleado')
    ]).then(function(values){
       console.log('Lo prometido...');
       self.set('sedesCache', values[0]);
       self.set('departamentosCache', values[1]);
       self.set('empleadosCache', values[2]);
       return values;
    });
    console.log('App Init');
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
