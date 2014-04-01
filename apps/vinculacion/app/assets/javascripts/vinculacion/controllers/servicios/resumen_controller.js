App.ServiciosResumenController = Ember.ArrayController.extend({
  needs: ["application", "solicitud", "servicios"],
  costototal: function() {
    // TODO: Calcular
    return "Faltan costeos";
  }.property(), 
});