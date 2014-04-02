App.ServicioController = Ember.ObjectController.extend({
  needs: ["application", "solicitud", "servicios"],

  servicio_datos: function() {
    servicio = this.get('model');

    var res = {
      titulo: servicio.get('nombre'),
      muestras: []
    };

    var costeos = servicio.get('costeos');
    var total = 0;
    servicio.get('muestras').forEach(function(m) {
      muestra = m;
      muestra.set('costeos', []);
      costeos.forEach(function(c) {
        if (c.get('muestra.id') == m.get('id') && (c.get('servicio.id') == servicio.get('id'))) {
          total = 0;
          c.get('costeo_detalle').forEach(function(d) {
            total += d.get('cantidad') * d.get('precio_unitario');
          });
          c.total = total;
          muestra.costeos.push(c);
        }
      });
      res.muestras.push(muestra);
    });

    return res;

  }.property('model.muestras_string'),

  showServicio: true,

  isInicial: function() {
    return this.get('model.status') == this.get('controllers.servicios.Status.inicial');
  }.property('model.status'),

  isEsperandoCosteo: function() {
    return this.get('model.status') == this.get('controllers.servicios.Status.esperando_costeo');
  }.property('model.status'),


  actions: {
    solicitaCosteo: function() {
      servicio = this.get('model');
      var self = this

      url = '/vinculacion/servicios/' + servicio.get('id') + '/solicitar_costeo';

      $.post(url).then(function(response) {
        if (!response.error) {
          self.get('controllers.application').notify('Se solicito costeo');
          servicio.set('status', response.servicio.status); 
          // XXX: En teoria no lo guardamos ya porque ya lo hizo /solicitar_costeo
          //servicio.save();
        } else {
          console.log('ERROR');
          console.log(response);
          self.get('controllers.application').notify('Error al solicitar costeo', 'alert-danger');  
        }
      });
   
    }
  }
});