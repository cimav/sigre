App.SolicitudesController = Ember.ArrayController.extend({
  solicitudesCount: Ember.computed.alias('length'),
  searchText: null,
  showSolicitudesList: true,

  searchChange: function() {
    console.log(this.searchText);
    results = this.store.find('solicitud', { q: this.searchText });
    this.set('content', results);
  }.observes('searchText'),

  sortProperties: ['codigo:desc'],
  sortedSolicitudes: Ember.computed.sort('model', 'sortProperties')

});