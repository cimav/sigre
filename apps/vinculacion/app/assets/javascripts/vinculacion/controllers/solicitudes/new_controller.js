App.SolicitudesNewController = Ember.ObjectController.extend({
  needs: ["application", 'cotizaciones', 'solicitudes'],
  isNotDirty: Ember.computed.not('content.isDirty'),
  selectedCliente: function() {
    if (this.get('cliente')) {
      this.set('clienteContactos', this.store.find('contacto', { cliente_id: this.get('cliente.id') }));
    }
  }.observes('cliente'),
  actions: {

    submit: function() {
      var solicitud = this.get('model');
      var self = this;

      var onSuccess = function(solicitud) {

        // despues de guardar una nueva solicitud
        // recarga la lista de solicitud_busqueda
        self.get('controllers.solicitudes').send('reloadModel');

        if(solicitud.get('tipo') == 1) {
          self.transitionToRoute('solicitud.edit', solicitud); // directo a editar
        } else {
          self.transitionToRoute('solicitud', solicitud);
        }
        self.get('controllers.application').notify('Se agrego nueva solicitud');
      };

      var onFail = function(solicitud) {
        self.get('controllers.application').notify('Error al agregar solicitud', 'alert-danger');
      };

      // asignación manual a raíz de que contactos_netmultix no tiene un Id real.
      this.set('contacto_netmultix_email', this.get('contacto_netmultix.cl06_email'));
      this.set('contacto_netmultix_nombre', this.get('contacto_netmultix.cl06_contacto'));
      this.set('pais_netmultix_nombre', this.get('cliente_netmultix.pais'));
      this.set('estado_netmultix_nombre', this.get('cliente_netmultix.estado'));
      this.set('ciudad_netmultix_nombre', this.get('cliente_netmultix.ciudad'));

      solicitud.save().then(onSuccess, onFail);
    }

  }

});
