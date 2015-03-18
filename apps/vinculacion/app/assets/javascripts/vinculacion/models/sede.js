App.Sede = DS.Model.extend({
  nombre:       DS.attr('string'),
  descripcion:  DS.attr('string'),
  solicitudes: DS.hasMany('solicitud'),

  servicios_bitacora: DS.hasMany('servicio_bitacora')
});