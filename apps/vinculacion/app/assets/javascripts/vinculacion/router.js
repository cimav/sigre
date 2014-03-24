// For more information see: http://emberjs.com/guides/routing/
App.Router.map(function () {
  this.resource('solicitudes', function () {
    this.route('new', {path: '/nueva'});
    this.resource('solicitud', {path: '/:solicitud_id'}, function () {
      this.route('edit', {path: '/detalles'})
      this.resource('muestras');
      this.resource('servicios', function () {
        this.route('new', {path: '/nuevo'});
        this.resource('servicio', {path: '/:servicio_id'}, function () {
          this.route('edit', {path: '/editar'})
        });
      });
    });
  });

  this.resource('clientes', function () {
    this.route('new', {path: '/nuevo'});
    this.resource('cliente', {path: '/:cliente_id'}, function () {
      this.resource('contactos', function(){
        this.route('new', {path: '/nuevo'});
        this.resource('contacto', {path: '/:contacto_id'}, function() {
          this.route('edit', {path: '/editar'});
        });
      });
    });
  });

});