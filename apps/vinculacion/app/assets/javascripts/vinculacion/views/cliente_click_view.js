App.ClienteClickView = Ember.View.extend({

  // Detecta el click sobre el Cliente para activar/mostrar sus Contactos
  // (Cliente.AfterModel no funciona cuando se selecciona a sí mismo.)
  click: function(evt) {
      this.get('controller.controllers.cliente').transitionToRoute('contactos');
  }

});
