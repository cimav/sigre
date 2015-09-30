App.CatalogoController = Ember.ArrayController.extend({
  searchText: null,

  sortByNombre: ['nombre:asc'],
  sortedCatalogo: Ember.computed.sort('arrangedContent', 'sortByNombre'),

  arrangedContent: function () {
    search = this.searchText;
    if (!search) {
      c = this.get('content');
    } else {
      c = this.get('content').filter(function (item) {
        data_string = item.get('nombre') + item.get('laboratorio_bitacora.nombre');
        data_string = data_string.toLowerCase();
        search = search.toLowerCase();
        found = data_string.indexOf(search) != -1;
        return found;
      });
    }
    return c;
  }.property('content', 'searchText'),

  searchChange: function () {
  
  }.observes('searchText')
  

});