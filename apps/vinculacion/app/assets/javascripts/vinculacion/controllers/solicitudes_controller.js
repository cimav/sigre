Ember.debouncedObserver = function(func, key, time) {
  return Em.observer(function() {
    Em.run.debounce(this, func, time);
  }, key)
};


App.SolicitudesController = Ember.ArrayController.extend({
  solicitudesCount: Ember.computed.alias('length'),
  searchText: null,
  showSolicitudesList: true,

  searchObserver: Ember.debouncedObserver(function() {
    console.log('DEBOUNCED SEARCH');
    console.log(this.searchText);
    var self = this;
    self.set('content', '');
    var results = self.store.find('solicitudBusqueda', { q: this.searchText });
    self.set('content', results);   
  }, 'searchText', 500)

  //sortProperties: ['codigo:desc'],
  //sortedSolicitudes: Ember.computed.sort('model', 'sortProperties')

});