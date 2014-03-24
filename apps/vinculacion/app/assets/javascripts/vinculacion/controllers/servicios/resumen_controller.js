App.ServiciosResumenController = Ember.ObjectController.extend({
  needs: ["application", "solicitud", "servicios"],
  costototal: '$9,999', // TODO: Calcular
});