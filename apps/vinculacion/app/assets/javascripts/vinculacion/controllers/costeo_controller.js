App.CosteoController = Ember.ObjectController.extend({
    needs: ['application'],

    saveMostrarLeyenda: function () {
        if (this.get('model.isDirty')) {
            costeo = this.get('model');
            self = this;
            var onSuccess = function (costeo) {
                self.get('controllers.application').notify('Se actualizón estado de leyenda');
            };
            var onFail = function (costeo) {
                self.get('controllers.application').notify('Error al actualizar estado de leyenda', 'alert-danger');
            };
            costeo.save();
        }
    }.observes('mostrar_leyenda', 'model.isDirty'),

});