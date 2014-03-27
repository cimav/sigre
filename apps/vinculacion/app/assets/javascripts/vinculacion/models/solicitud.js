App.Solicitud = DS.Model.extend({
  codigo:          DS.attr('string'),
  notas:           DS.attr('string'),
  acuerdos:        DS.attr('string'),
  contacto_email:  DS.attr('string'),
  prioridad:       DS.attr('string'),
  muestras:        DS.hasMany('muestra'),
  servicios:       DS.hasMany('servicio'),
  proyecto:        DS.belongsTo('proyecto')
});
