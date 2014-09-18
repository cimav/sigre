App.Recurso = DS.Model.extend({
  nombre: DS.attr('string'),
  descripcion:  DS.attr('string'),

  tipo: DS.belongsTo('tipo'),
  fondos: DS.hasMany('fondo'),

  id_nombre: function() {
    // a desplegar en el select
    return this.get('id') + " " + this.get('nombre');
  }.property('nombre'),

  sortedFondos: function(){
    // listado ordenado para el select
    return this.get('fondos').sortBy('id');
  }.property('fondos.@each.isLoaded')


});