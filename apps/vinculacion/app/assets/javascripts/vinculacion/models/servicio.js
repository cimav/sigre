App.Servicio = DS.Model.extend({
  nombre: DS.attr('string'),
  descripcion: DS.attr('string'),
  solicitud: DS.belongsTo('solicitud'),
  empleado: DS.belongsTo('empleado'),
  consecutivo: DS.attr('string'),
  codigo: DS.attr('string'),
  status: DS.attr('number'),
  muestras: DS.hasMany('muestra'),
  precio_sugerido: DS.attr('number'),
  costeos: DS.hasMany('costeo'),

  status_text: DS.attr('string'),
  muestras_string: DS.attr('string'),
  relation_string: DS.attr('string'),

  servicio_bitacora: DS.belongsTo('servicio_bitacora'),

  selectsChanges: function () {
    if (!this.get('isDeleted')) {
      // Hack: belongsTo no cambian a Dirty
      // Info de porque no cambian: https://github.com/emberjs/data/issues/1188
      s = [this.get('empleado.id'), this.get('solicitud.id')].join(',');
      this.set('relation_string', s);
    }
  }.observes('empleado','solicitud')

});
