App.ProyectosController = Ember.ArrayController.extend({
  needs: [],

  searchText: null,
//  showProyectosList: true,
  firstRecord: null,

  // sortProperties: ['id:desc'], no para numeros
  sortedProyectos: Ember.computed.sort('model', function(a, b){return b.id - a.id})

  //http://balinterdi.com/2014/03/05/sorting-arrays-in-ember-dot-js-by-various-criteria.html

//  arrangedContent: function () {
//    search = this.searchText;
//    firstRecord = null;
//    if (!search) {
//      f = this.get('content').get('firstObject');
//      if (f) {
//        firstRecord = f.id;
//      }
//      return this.get('content');
//    }
//    return this.get('content').filter(function (item) {
//      data_string = item.get('codigo') + item.get('descripcion');
//      data_string = data_string.toLowerCase();
//      search = search.toLowerCase();
//      found = data_string.indexOf(search) != -1;
//      if (found && !firstRecord) firstRecord = item.id;
//      return found;
//    })
//  }.property('content', 'searchText'),
//  searchChange: function () {
//    if (firstRecord) {
//      this.transitionToRoute('proyecto', firstRecord);
//    }
//  }.observes('searchText')

});
