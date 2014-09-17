// For more information see: http://emberjs.com/guides/routing/

App.Router.map(function() {
  this.resource('proyectos', function () {
    this.route('new', {path: '/nuevo'});
    this.resource('proyecto', {path: '/:proyecto_id'}, function () {
      this.route('edit', {path: '/editar'});
    });
  });
});

