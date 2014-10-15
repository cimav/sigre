App.CurrentUserController = Ember.ObjectController.extend({

  isSignedIn: function() {
    return this.get('content') !== null;
  }.property('content'),

  isNotAdmin: function() {
    return this.get('model.role') !== "admin"
  }.property()

});
