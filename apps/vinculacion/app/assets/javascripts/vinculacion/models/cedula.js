App.Cedula = DS.Model.extend({

  solicitud: DS.belongsTo('solicitud'),
  servicio: DS.belongsTo('servicio'),

  codigo: DS.attr('string'),
  status: DS.attr('number'),

  costos_variables: DS.hasMany('costo_variable'),
  remanentes: DS.hasMany('remanente'),

  total_costo_variable: DS.attr('number'),
  costo_indirecto: DS.attr('number'),
  costo_interno: DS.attr('number'),
  porcentaje_participacion: DS.attr('number'),
  precio_venta: DS.attr('number'),
  utilidad_neta: DS.attr('number'),
  utilidad_topada: DS.attr('number'),
  remanente_distribuible: DS.attr('number'),

  cedula_netmultix: DS.attr('string'),
  cliente_netmultix: DS.belongsTo('cliente_netmultix'),
  concepto_en_extenso: DS.attr('string')


});