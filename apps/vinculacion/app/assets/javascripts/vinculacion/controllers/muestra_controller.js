App.MuestraController = Ember.ObjectController.extend({
  isNotDirty: Ember.computed.not('content.isDirty')
});