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

  renderTemplate: function() {
    this.render();
    this.render('cotizacion/edit_save_button', { 
      into: 'cotizacion',
      outlet: 'cotizacion-header',
      controller: 'cotizacionEdit' 
    });
  },
  model: function () {
    return this.modelFor('cotizacion');
  },
  setupController: function(controller, model) {
    this._super(controller, model);
    var newDetalle = this.store.createRecord('cotizacion_detalle');
    newDetalle.set('cantidad', 1);
    newDetalle.set('precio_unitario', 0);
    controller.set('newDetalle', newDetalle);
  }
});