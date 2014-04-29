App.CotizacionEditRoute = Ember.Route.extend({
  activate: function () {
    this.controllerFor('cotizacion').set('showCotizacion', false);
    this.controllerFor('cotizacion').set('showToolBar', false);
  },
  deactivate: function () {

    // deshacer cambios no guardados
    if (this.currentModel.get('isDirty')) {
      this.currentModel.rollback();
    }

    this.controllerFor('cotizacion').set('showCotizacion', true);
    this.controllerFor('cotizacion').set('showToolBar', true);

  },
  model: function () {
    return this.modelFor('cotizacion');
  },
  setupController: function(controller, model) {
    this._super(controller, model);
    controller.set('newDetalle', this.store.createRecord('cotizacion_detalle'));
  }
});