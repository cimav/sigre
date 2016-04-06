App.ClienteNetmultix = DS.Model.extend({
  cl01_clave:   DS.attr('string'),
  cl01_nombre:  DS.attr('string'),
  cl01_rfc:     DS.attr('string'),

  contactos_netmultix: DS.hasMany('contacto_netmultix')

});

