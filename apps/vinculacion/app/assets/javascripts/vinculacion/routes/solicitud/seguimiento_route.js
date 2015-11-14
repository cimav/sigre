App.SolicitudSeguimientoRoute = Ember.Route.extend({
  model: function() {
    return this.modelFor('solicitud');
  },
  afterModel: function() {
    m = this.modelFor(this.routeName);
    $.get('/vinculacion/seguimiento/' + m.get('vinculacion_hash'), function( data ) {
      $( "#seguimiento" ).html( data );
    });
  },
  activate: function() {
    
  },
  deactivate: function() {
  }
});