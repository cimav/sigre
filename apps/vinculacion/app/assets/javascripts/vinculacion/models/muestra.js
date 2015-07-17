App.Muestra = DS.Model.extend({
  codigo:            DS.attr('string'),
  identificacion:    DS.attr('string'),
  descripcion:       DS.attr('string'),
  cantidad:          DS.attr('number'),
  solicitud_id:      DS.attr('number'),
  solicitud:         DS.belongsTo('solicitud'),
  servicio:          DS.belongsTo('servicio'),
  status:            DS.attr('number'),

  muestras_detalle: DS.hasMany('muestra_detalle'),

  descripcionLarga: function() {
    //return Ember.String.htmlSafe("<h1>" + this.get('codigo') + "</h1>" + "<h4>" + this.get('identificacion') + "</h4>");
    return this.get('codigo') + ' ' + this.get('identificacion') + ' ' + this.get('descripcion');
  }.property('codigo')

});
