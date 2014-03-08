App.SolicitudController = Ember.ObjectController.extend({
  needs: ["muestras"],
  isNotDirty: Ember.computed.not('content.isDirty')
});