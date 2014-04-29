App.ClienteClickView = Ember.View.extend({
//    init: function() {
//        this._super();
//        this.set("controller", "cliente");
//    },

  // Detecta el click sobre el Cliente para activar/mostrar sus Contactos
  // (Cliente.AfterModel no funciona cuando se selecciona a sí mismo.)
    click: function(evt) {
      // TODO Al darle Click al Cliente, debe re-cargar la ruta de contactos.
      //console.log(App.controller);
    }

});
