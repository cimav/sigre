App.Tipo = DS.Model.extend({
  nombre: DS.attr('string'),

  recursos: DS.hasMany('recurso'),

  id_nombre: function() {
    // a desplegar en el select
    return this.get('id') + " " + this.get('nombre');
  }.property('nombre'),

  sortedRecursos: function(){
    // listado ordenado de recursos para el select
    return this.get('recursos').sortBy('id');
  }.property('recursos.@each.isLoaded')
});