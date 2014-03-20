// For more information see: http://emberjs.com/guides/routing/
App.Router.map(function() {
  //this.resource('solicitudes', function() {
  //  this.route('new');
  //  this.resource('solicitud', {path: '/:solicitud_id'});
  //});
  //this.route('solicitud', {path: '/solicitudes/:solicitud_id'});
  //this.route('solicitudes.new', {path: '/solicitudes/nueva'});
  this.resource('solicitudes', function() {
  	this.route('new', {path: '/nueva'});
    this.resource('solicitud', {path: '/:solicitud_id'}, function() {
      this.route('edit', {path: '/detalles'})
      this.resource('muestras', function() {
        this.route('new', {path: '/nueva'});  
      });
      this.resource('servicios', function() {
        this.route('new', {path: '/nuevo'});  
      });
    });
  });

    this.resource('clientes', function() {
        this.route('new', {path: '/nuevo'});
        this.resource('cliente', {path: '/:cliente_id'});
    });

});