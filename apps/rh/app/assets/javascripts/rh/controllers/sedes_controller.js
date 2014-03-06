App.SedesController = Ember.ArrayController.extend({
  sedesCount: Ember.computed.alias('length'),
  searchText: null,
  firstRecord: null,
  arrangedContent: function() {
  	search = this.searchText;
  	firstRecord = null;
    if (!search) { 
      f = this.get('content').get('firstObject');
      if (f) {
        firstRecord = f.id;
        //this.transitionToRoute('sede', firstRecord);
      } 
      return this.get('content'); 
    }
    return this.get('content').filter(function(item) {   
      data_string = item.get('nombre') + item.get('descripcion');
      data_string = data_string.toLowerCase();
      search = search.toLowerCase();
      found = data_string.indexOf(search) != -1;
      if (found && !firstRecord) firstRecord = item.id;
      return found;
    })
  }.property('content', 'searchText'),
  searchChange: function() {
    if (firstRecord) {
      this.transitionToRoute('sede', firstRecord);
    }
  }.observes('searchText')
});