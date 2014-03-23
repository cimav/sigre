App.ServicioEditController = Ember.ObjectController.extend({
  needs: ["application", "solicitud"],
  isNotDirty: Ember.computed.not('content.isDirty'),
  actions: {
    submit: function() {
      this.get('model').save();
      this.get('controllers.application').notify('Servicio actualizado');
    }
  }
});

App.EditChildController = Ember.ObjectController.extend({    
    selected: function() {
        var servicio = this.get('content');
        var muestras = this.get('parentController.muestras');
        console.log('EDIT selected');
        return muestras.contains(servicio);
    }.property(),
    selectedChanged: function() {
        console.log('EDIT selected changed');
        var servicio = this.get('content');
        var muestras = this.get('parentController.muestras');
        if (this.get('selected')) {                                    
            muestras.pushObject(servicio);            
        } else {                                    
            muestras.removeObject(servicio);                                                    
        }        
    }.observes('selected')
});