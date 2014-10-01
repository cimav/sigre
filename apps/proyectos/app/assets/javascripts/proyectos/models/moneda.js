App.Moneda = DS.Model.extend({
  codigo: DS.attr('string'),
  nombre: DS.attr('string'),

  codigo_nombre: function() {
    // a desplegar en el select
    return this.get('codigo') + " " + this.get('nombre');
  }.property('codigo')

});

