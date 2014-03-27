App.Empleado = DS.Model.extend({
  nombre:            DS.attr('string'),
  apellido_paterno:  DS.attr('string'),
  apellido_materno:  DS.attr('string'),
  email:             DS.attr('string'),
  telefono:          DS.attr('string'),
  nombre_completo:   DS.attr('string'),
  avatar_url:   DS.attr('string'),
  mailto:  function() {
    return 'mailto:' + this.get('email');
  }.property('email')
  //sede:              DS.belongsTo('sede'),
  //departamento:      DS.belongsTo('departamento'),
  //empleado:          DS.belongsTo('empleado'),
});