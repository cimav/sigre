SolicitudesView = Ember.View.extend({
  didInsertElement: function(){
    Ember.$('.contacto-descripcion').tooltip({html : true});
  }
});
