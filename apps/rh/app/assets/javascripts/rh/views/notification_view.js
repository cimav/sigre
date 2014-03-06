App.NotificationView = Ember.View.extend({
  notificationDidChange: function() {
    that = this;
    if (this.get('notification') !== null) {
      if (this.get('notification_type') === 'alert-success') {
        this.$().fadeIn().delay(1200).fadeOut(300, function() { 
          that.set('notification', null);
          that.set('notification_type', 'alert-success');
        });
      } else {
        this.$().fadeIn();
      }
    } 
  }.observes('notification'),

  actions: {
    close: function() {
      that = this;
      this.$().fadeOut(300, function() {
        that.set('notification', null);
        that.set('notification_type', 'alert-success');
      });
    }
  },

  template: Ember.Handlebars.compile(
    '{{#if view.notification_type}}' +
    '<div {{bind-attr class=":app-notification :alert :alert-dismissable view.notification_type"}}>' +
    '  <button type="button" {{action \'close\' target=\'view\'}} class="close" data-dismiss="alert" aria-hidden="true">&times;</button>' +
    '  {{view.notification}}' +
    '</div>' +
    '{{/if}}'
  )
});