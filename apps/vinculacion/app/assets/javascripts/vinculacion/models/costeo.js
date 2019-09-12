App.Costeo = DS.Model.extend({
  codigo:          DS.attr('string'),
  nombre_servicio: DS.attr('string'),
  muestra:         DS.belongsTo('muestra'),
  servicio:        DS.belongsTo('servicio'),
  costeo_detalle:  DS.hasMany('costeo_detalle'),
  bitacora_id:     DS.attr('number'),
  status:          DS.attr('number'),
  leyenda:         DS.attr('string'),
  mostrar_leyenda: DS.attr('boolean'),
  head_id: function() {
    return "costeo_heading" + this.get('id');
  }.property('id'),
  collapse_id: function() {
    return "costeo_collapse" + this.get('id');
  }.property('id'),
  href_id: function() {
    return "#costeo_collapse" + this.get('id');
  }.property('id'),
  alert_url: function() {
    return "http://bitacora.cimav.edu.mx/laboratory_services/" + this.get('bitacora_id') + "/status_by_rs";
  }.property('bitacora_id'),
  hasLeyenda: function() {
    return this.get('leyenda') !=null && this.get('leyenda').length > 3;
  }.property('leyenda')
});