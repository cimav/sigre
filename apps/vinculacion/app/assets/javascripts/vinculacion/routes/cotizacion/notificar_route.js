App.CotizacionNotificarRoute = Ember.Route.extend({
  activate: function () {
    this.controllerFor('cotizacion').set('showToolBar', false);
  },
  deactivate: function () {

    if (this.currentModel.get('isDirty')) {
      this.currentModel.rollback();
    }

    this.controllerFor('cotizacion').set('showToolBar', true);
  },

  model: function () {
    return this.modelFor('cotizacion');
  }
});