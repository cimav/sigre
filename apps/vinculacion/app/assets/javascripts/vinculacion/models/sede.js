App.Sede = DS.Model.extend({
  nombre:       DS.attr('string'),
  descripcion:  DS.attr('string'),
  solicitudes: DS.hasMany('solicitud', {async: true}),

  servicios_bitacora: DS.hasMany('servicio_bitacora')
});