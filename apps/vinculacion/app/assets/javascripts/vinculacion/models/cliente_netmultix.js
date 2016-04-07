App.ClienteNetmultix = DS.Model.extend({
  cl01_clave:   DS.attr('string'),
  cl01_nombre:  DS.attr('string'),
  cl01_rfc:     DS.attr('string'),

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
  }.observes('id').property('id')

});

