App.XSolicitudesController = Ember.ArrayController.extend({
  solicitudesCount: Ember.computed.alias('length'),
  searchText: null,
  firstRecord: null,
  arrangedContent: function() {
  	search = this.searchText;
  	firstRecord = null;
    if (!search) { 
      f = this.get('content').get('firstObject');
      if (f) {
        firstRecord = f.id;
        this.transitionToRoute('solicitudes', firstRecord);
      } 
      return this.get('content'); 
    }
    return this.get('content').filter(function(item) {   
      data_string = item.get('codigo') + item.get('notas');
      data_string = data_string.toLowerCase();
      search = search.toLowerCase();
      found = data_string.indexOf(search) != -1;
      if (found && !firstRecord) firstRecord = item.id;
      return found;
    })
  }.property('content', 'searchText'),
  searchChange: function() {
    if (firstRecord) {
      this.transitionToRoute('solicitudes', firstRecord);
    }
  }.observes('searchText')
});


App.SolicitudesController = GRID.TableController.extend({
    toolbar: [ GRID.ColumnSelector, GRID.Filter ],
    columns: [
        GRID.column('id', { display: 'always' }),
        GRID.column('notas')
    ]
});

