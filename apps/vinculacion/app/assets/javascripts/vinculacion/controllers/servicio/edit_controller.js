App.ServicioEditController = Ember.ObjectController.extend({
  needs: ["application", "solicitud", "servicios"],
  isNotDirty: Ember.computed.not('content.isDirty'),
  actions: {
    submit: function() {
      servicio = this.get('model');
      servicio.set('solicitud', this.get('controllers.solicitud').get('model'));
      servicio.save();
      this.transitionToRoute('servicio', servicio);
      this.get('controllers.application').notify('Servicio actualizado');
    }
  }
});

App.EditChildController = Ember.ObjectController.extend({    
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