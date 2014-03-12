// For more information see: http://emberjs.com/guides/routing/
App.Router.map(function() {
  //this.resource('solicitudes', function() {
  //  this.route('new');
  //  this.resource('solicitud', {path: '/:solicitud_id'});
  //});
  //this.route('solicitudes.new', {path: '/solicitudes/nueva'});
  this.resource('solicitudes', function() {
  	this.route('new', {path: '/nueva'});
    this.resource('solicitud', {path: '/:solicitud_id'});
  });
});