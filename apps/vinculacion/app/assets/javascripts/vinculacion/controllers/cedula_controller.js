App.CedulaController = Ember.ObjectController.extend({

  total_porcentaje: function() {
    var remanentes = this.get('model.remanentes');
    var result = 0.00;
    remanentes.forEach(function (rem) {
      result = result + rem.get('porcentaje_participacion');
    });
    return result;
  }.property('model.porcentaje_participacion'),

  chk_total_porcentaje: function() {
    var result = this.get('total_porcentaje') == 100;
    return result;
  }.property('total_porcentaje'),

  has_costos_class: function() {
    var result = "";
    if (this.get('model.costos_variables.length') == 0) {
      result = "div-costos-variables-remanente-opacity";
    }
    return result;
  }.property('model.costos_variables')

});