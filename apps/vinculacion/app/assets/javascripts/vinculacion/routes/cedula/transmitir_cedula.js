App.CedulaEditRoute = Ember.Route.extend({
    deactivate: function () {
        if (this.currentModel.get('isDirty')) {
            this.currentModel.rollback();
        }
    },

    /*
     renderTemplate: function() {
     this.render({ outlet: 'accion-cotizacion' });
     this.render('cotizacion/solicitar_descuento_button', {
     into: 'cotizacion',
     outlet: 'cotizacion-header',
     controller: 'cotizacionSolicitarDescuento'
     });
     },
     */

    model: function () {
        return this.modelFor('cedula');
    }
});