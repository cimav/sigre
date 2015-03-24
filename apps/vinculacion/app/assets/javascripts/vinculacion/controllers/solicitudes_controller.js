App.SolicitudesController = Ember.ArrayController.extend({
  solicitudesCount: Ember.computed.alias('length'),
  searchText: null,
  showSolicitudesList: true,

  searchChange: function() {
    console.log(this.searchText);
    var self = this;
    self.set('content', '');
    var results = self.store.find('solicitudBusqueda', { q: this.searchText });
    self.set('content', results);
  }.observes('searchText'),

  sortProperties: ['codigo:desc'],
  sortedSolicitudes: Ember.computed.sort('model', 'sortProperties')

});