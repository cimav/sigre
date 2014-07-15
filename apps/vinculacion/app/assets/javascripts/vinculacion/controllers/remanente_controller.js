App.RemanenteController = Ember.ObjectController.extend({

  monto: function() {
    var result = this.get('model.porcentaje_participacion') * this.get('cedula.remanente_distribuible') / 100;
    return result;
  }.property('model.porcentaje_participacion'),

});