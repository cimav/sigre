App.ServiciosResumenController = Ember.ObjectController.extend({
  needs: ["application", "solicitud", "servicios"],
  costototal: function() {
    // TODO: Calcular
    return "Faltan costeos";
  }.property(), 
});