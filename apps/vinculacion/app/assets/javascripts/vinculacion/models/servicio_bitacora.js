App.ServicioBitacora = DS.Model.extend({
  bitacora_id:    DS.attr('number'),
  nombre:         DS.attr('string'),
  descripcion:    DS.attr('string'),
  precio_venta:   DS.attr('number'),
  costo_interno:  DS.attr('number'),
  status:         DS.attr('number'),
  empleado:       DS.belongsTo('empleado'),
  sede:           DS.belongsTo('sede'),
  laboratorio_bitacora:    DS.belongsTo('laboratorio_bitacora')

});
