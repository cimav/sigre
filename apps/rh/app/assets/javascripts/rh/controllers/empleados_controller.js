App.EmpleadosController = Ember.ArrayController.extend({
  empleadosCount: Ember.computed.alias('length'),
  searchText: null,
  firstRecord: null,
  arrangedContent: function() {
  	search = this.searchText;
  	firstRecord = null;
    if (!search) { 
      return this.get('content'); 
    }
    return this.get('content').filter(function(item) {   
      data_string = item.get('nombre') + item.get('apellido_paterno') + item.get('apellido_materno');
      data_string = data_string.toLowerCase();
      search = search.toLowerCase();
      found = data_string.indexOf(search) != -1;
      if (found && !firstRecord) firstRecord = item.id;
      return found;
    })
  }.property('content', 'searchText'),
  searchChange: function() {
    if (firstRecord) {
      this.transitionToRoute('empleado', firstRecord);
    }
  }.observes('searchText')
});