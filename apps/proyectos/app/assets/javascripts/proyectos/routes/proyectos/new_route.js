App.ProyectosNewRoute = Ember.Route.extend({
  model: function() {
    var fechaInicio = new Date();
    var fechaFin = new Date();
    var mes = fechaInicio.getMonth() < 11 ? fechaInicio.getMonth() + 1 : 0;
    fechaFin.setMonth(mes);
    var newProyecto = this.store.createRecord('proyecto', {
      anio: fechaInicio.getFullYear(),
      fecha_inicio: fechaInicio,
      fecha_fin: fechaFin
    });

    return newProyecto;
  },

  activate: function () {
    this.controllerFor('proyectos').set('showProyectosList', false);
  },

  deactivate: function () {
    this.controllerFor('proyectos').set('showProyectosList', true);
  },

  shortcuts: {
    'shift+g': 'callSubmit'
  },

  actions: {
    callSubmit: function() {
      this.get('controller').send('submit');
    }
  }

});
