App.ClienteNetmultix = DS.Model.extend({
  cl01_clave:         DS.attr('string'),
  cl01_nombre:        DS.attr('string'),
  cl01_rfc:           DS.attr('string'),
  cl01_lada:          DS.attr('string'),
  cl01_telefono1:     DS.attr('string'),
  cl01_tipo_cliente:  DS.attr('number'),
  cl01_tipo_empresa:  DS.attr('number'),
  cl01_empleados:     DS.attr('number'),

  contactos_netmultix: DS.hasMany('contacto_netmultix'),

  has_contactos: function () {
    return this.get('contactos_netmultix').get('length') > 0;
  }.observes('id').property('id'),

  collapsable_id: function() {
    var r = "collapse_" + this.get('id');
    return r;
  }.observes('id').property('id'),
  collapsable_href: function() {
    var r = "#collapse_" + this.get('id');
    return r;
  }.observes('id').property('id'),

  telefono: function() {
    return !this.get('cl01_lada').isEmpty ? "("+ this.get('cl01_lada') + ") " + this.get('cl01_telefono1') : this.get('cl01_telefono1');
  }.property('cl01_lada')

});

