App.Proyecto = DS.Model.extend(Ember.Validations.Mixin, {
  codigo: DS.attr('string'),
  nombre: DS.attr('string'),
  solicitudes: DS.hasMany('solicitud')

});
