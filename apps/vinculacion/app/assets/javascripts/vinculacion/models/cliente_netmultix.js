App.ClienteNetmultix = DS.Model.extend({
  cl01_clave:   DS.attr('string'),
  cl01_nombre:  DS.attr('string'),
  cl01_rfc:     DS.attr('string'),

  contactos_netmultix: DS.hasMany('contacto_netmultix'),

  collapsable_id: function() {
    var r = "collapse_" + this.get('id');
    console.log(r);
    return r;
  }.observes('id').property('id'),
  collapsable_href: function() {
    var r = "#collapse_" + this.get('id');
    console.log(r);
    return r;
  }.observes('id').property('id')

});

