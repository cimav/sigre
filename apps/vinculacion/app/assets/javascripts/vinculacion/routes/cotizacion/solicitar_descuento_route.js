App.CotizacionSolicitarDescuentoRoute = Ember.Route.extend({
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
    this.render('cotizacion/solicitar_descuento_button', {
      into: 'cotizacion',
      outlet: 'cotizacion-header',
      controller: 'cotizacionSolicitarDescuento'
    });
  },

  model: function () {
    return this.modelFor('cotizacion');
  }
});
