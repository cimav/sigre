App.Usuario = DS.Model.extend({
  usuario:    DS.attr('string'),
  email:      DS.attr('string'),
  nombre:     DS.attr('string'),
  apellidos:  DS.attr('string'),
  role:       DS.attr('string'),
  status:     DS.attr('number')

});

