App.ServiciosController = Ember.ArrayController.extend({
  needs: ["application", "solicitud"],
  Status: {
    inicial:            1,
    esperando_costeo:   2,
    esperando_arranque: 3,
    en_proceso:         4,
    finalizado:         5,
    cancelado:         99
  }
});