App.MuestraDetalle = DS.Model.extend({
  muestra: DS.belongsTo('muestra'),
  consecutivo: DS.attr('number'),
  cliente_identificacion: DS.attr('string'),
  notas: DS.attr('string'),
  status: DS.attr('number'),

  id_cimav: function() {
    var result = this.get('muestra').get('solicitud.codigo');
    return result + '-' + String("000" + this.get('consecutivo')).slice(-3);
  }.property('consecutivo')


});