App.Fondo = DS.Model.extend({
  nombre: DS.attr('string'),
  descripcion:  DS.attr('string'),

  recurso: DS.belongsTo('recurso'),

  id_nombre: function() {
    // a desplegar en el select
    return this.get('id') + " " + this.get('nombre');
  }.property('nombre')

});