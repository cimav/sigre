// For more information see: http://emberjs.com/guides/routing/
App.Router.map(function () {
  this.resource('solicitudes', function () {
    this.route('new', {path: '/nueva'});
    this.resource('solicitud', {path: '/:solicitud_id'}, function () {
      this.route('seguimiento', {path: '/seguimiento'});
      this.route('edit', {path: '/editar'});
      this.route('cancelacion', {path: '/cancelacion'});

      this.resource('muestras', function() {
        this.resource('muestra', {path: '/:muestra_id'}, function () {
          this.route('edit', {path: '/editar'});
        });
        this.resource('muestra', { path: '/:solicitud_id' });
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
          this.route('solicitar_descuento');
          this.route('rechazar');
          this.route('aceptar');
        });
      });

      this.resource('arrancar', {path: '/arrancar'});

      this.resource('cedulas', {path: '/cedulas'}, function(){
        this.resource('cedula', {path: '/:cedula_id'}, function() {
          this.resource('costos_variables', {path: '/variables'});
          this.resource('remanentes', {path: '/remanentes'});
        });
      });

    });
  });

  this.resource('proyectos', function () {
    this.route('new', {path: '/nuevo'});
    this.resource('proyecto', {path: '/:proyecto_id'}, function () {
      this.route('edit', {path: '/editar'});
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

  this.resource('clientes_netmultix', function () {
  });

  this.resource('catalogo', function () {
  });

});