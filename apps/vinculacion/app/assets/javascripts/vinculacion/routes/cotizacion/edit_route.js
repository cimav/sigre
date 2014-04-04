App.CotizacionEditRoute = Ember.Route.extend({
  activate: function() {
    this.controllerFor('cotizacion').set('showCotizacion', false);
  },
  deactivate: function() {

    // deshacer cambios no guardados
    if (this.currentModel.get('isDirty')) {
      this.currentModel.rollback();
    }

    this.controllerFor('cotizacion').set('showCotizacion', true);
  },
  model: function () {
    return this.modelFor('cotizacion');
  }
});