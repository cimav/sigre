App.Proyecto = DS.Model.extend(Ember.Validations.Mixin, {
  cuenta: DS.attr('string'),
  nombre: DS.attr('string'),
  descripcion: DS.attr('string'),

});
