App.MyModalComponent = Ember.Component.extend({
  actions: {
    ok_modal: function() {
      this.$('.modal').modal('hide');
      this.sendAction('ok'); //pasarle el Ok al controller
    }
  },
  show: function() {
    this.$('.modal').modal().on('hidden.bs.modal', function() {
      this.sendAction('close');
    }.bind(this));
  }.on('didInsertElement')

});
