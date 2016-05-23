App.CedulaRoute = Ember.Route.extend({

    beforeModel: function() {
        if (this.modelFor('cedula')  !== undefined && this.modelFor('cedula').get('isDirty')) {
            //deshace los cambios
            this.modelFor('cedula').rollback();
        }
    },

    deactivate: function () {
        // deshacer cambios no guardados
        if (this.currentModel.get('isDirty')) {
            this.currentModel.rollback();
        }
    }

});