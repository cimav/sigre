/**
 * Created by calderon on 3/12/14.
 */

App.ClientesController = Ember.ArrayController.extend({
    clientesCount: Ember.computed.alias('length'),
    searchText: null,
    firstRecord: null,
    arrangedContent: function() {
        search = this.searchText;
        firstRecord = null;
        if (!search) {
            f = this.get('content').get('firstObject');
            if (f) {
                firstRecord = f.id;
                //this.transitionToRoute('muestra', firstRecord);
            }
            return this.get('content');
        }
        return this.get('content').filter(function(item) {
            data_string = item.get('rfc') + item.get('nombre');
            data_string = data_string.toLowerCase();
            search = search.toLowerCase();
            found = data_string.indexOf(search) != -1;
            if (found && !firstRecord) firstRecord = item.id;
            return found;
        })
    }.property('content', 'searchText'),
    searchChange: function() {
        if (firstRecord) {
            this.transitionToRoute('cliente', firstRecord);
        }
    }.observes('searchText')
});