App.ServiciosNewController = Ember.ObjectController.extend({
  needs: ["application", "solicitud"],
  isNotDirty: Ember.computed.not('content.isDirty'),
  actions: {
    submit: function() {
      servicio = this.get('model');
      self = this
      var onSuccess = function(servicio) {
        self.transitionToRoute('servicio', servicio);
        self.get('controllers.application').notify('Se agrego nueva servicio');
      };

      var onFail = function(servicio) {
        self.get('controllers.application').notify('Error al agregar servicio', 'alert-danger');
      };
      self.get('controllers.solicitud').get('model').get('servicios').pushObject(servicio);
      servicio.save().then(onSuccess, onFail);
    }
  }
});

App.NewChildController = Ember.ObjectController.extend({    
  selected: function() {
    var muestra = this.get('content');
    var muestras = this.get('parentController.muestras');
    return muestras.contains(muestra);
  }.property(),
  selectedChanged: function() {
    var muestra = this.get('content');
    var servicio = this.get('parentController').get('model');
    var muestras = this.get('parentController.muestras');
    if (this.get('selected')) {                                    
      muestras.pushObject(muestra);          
    } else {                                    
      muestras.removeObject(muestra);
    }        
    var selected_muestras = muestras.map(function(el) { return el.id}).toArray().join();
    servicio.set('muestras_string', selected_muestras);
  }.observes('selected') 
});