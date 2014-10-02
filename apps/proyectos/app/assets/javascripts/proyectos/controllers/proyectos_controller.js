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

  proyectosBaseCache: function(){
    self = this;
    this.get('sortedProyectos').forEach(function(proyectoB){
      if (proyectoB.get('isProyectoBase')) {
        var idProy = proyectoB.get('id');
        self.store.find('proyecto', idProy).then(function(proy){
          if (!self.get('proyectosBaseCache').contains(proy)) {
            self.get('proyectosBaseCache').pushObject(proy);
          }
        });
      }
    });
    return Ember.A();
  }.property('')

});
