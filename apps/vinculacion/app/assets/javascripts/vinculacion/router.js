// For more information see: http://emberjs.com/guides/routing/
App.Router.map(function() {
  this.resource('solicitudes', function() {
    this.route('new');
    this.resource('solicitud', {path: '/:solicitud_id'});
  });
});