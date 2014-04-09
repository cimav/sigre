// For more information see: http://emberjs.com/guides/routing/
App.Router.map(function () {
  this.resource('solicitudes', function () {
    this.route('new', {path: '/nueva'});
    this.resource('solicitud', {path: '/:solicitud_id'}, function () {
      
      this.route('edit', {path: '/detalles'})
      
      this.resource('muestras', function() {
        this.resource('muestra', {path: '/:muestra_id'}, function () {
          this.route('edit', {path: '/editar'});
        });
      });
      
      this.resource('servicios', function () {
        this.route('resumen', {path: '/resumen'});
        this.route('new', {path: '/nuevo'});
        this.resource('servicio', {path: '/:servicio_id'}, function () {
          this.route('edit', {path: '/editar'});
        });
      });

      this.resource('cotizaciones', function() {
        this.resource('cotizacion', {path: '/:cotizacion_id'}, function(){
          this.route('edit', {path: '/editar'});
          this.route('notificar');
          this.route('rechazar');
          this.route('aceptar');
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