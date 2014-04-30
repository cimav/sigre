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

  renderTemplate: function() {
    this.render({ outlet: 'accion-cotizacion' });
  },

  model: function () {
    return this.modelFor('cotizacion');
  }
});