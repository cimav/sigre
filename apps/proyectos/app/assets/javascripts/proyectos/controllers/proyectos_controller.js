App.ProyectosController = Ember.ArrayController.extend({
  proyectosCount: Ember.computed.alias('length'),
  searchText: null,
  showProyectosList: true, //controlada en la ruta

  searchChange: function() {
    console.log(this.searchText);
    results = this.store.find('proyectoBusqueda', { q: this.searchText });
    this.set('content', results);
  }.observes('searchText'),

  sortProperties: ['cuenta:desc'],
  sortedProyectos: Ember.computed.sort('model', 'sortProperties')

});
