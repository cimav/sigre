// For more information see: http://emberjs.com/guides/routing/
App.Router.map(function() {

  this.resource('empleados', function() {
    this.resource('empleado', {path: '/:empleado_id'});
    this.route('new');
  });

  this.resource('departamentos', function() {
    this.resource('departamento', {path: '/:departamento_id'});
    this.route('new');
  });

  this.resource('sedes', function() {
    this.resource('sede', {path: '/:sede_id'});
    this.route('new');
  });

});