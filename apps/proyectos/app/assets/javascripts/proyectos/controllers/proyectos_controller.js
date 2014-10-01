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
  sortedProyectos: Ember.computed.sort('model', 'sortProperties'),

//  proyectosBase: Ember.computed.filter('sortedProyectos', function(proyecto) {
//    return proyecto.get('isProyectoBase');
//  }),
//  proyectosBaseArray: function(){
//    var result = Ember.A();
//    for (i = 0; i < this.get('proyectosBase.length'); i++) {
//      var id = this.get('proyectosBase')[i].get('id');
//      this.store.find('proyecto', id).then(function(proy){
//        result.push(proy)
//      });
//    }
//    return result;
//  }.property('proyectosBase')

});
