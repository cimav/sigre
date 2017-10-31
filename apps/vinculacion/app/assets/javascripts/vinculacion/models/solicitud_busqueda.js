App.SolicitudBusqueda = DS.Model.extend({
  codigo: DS.attr('string'),
  descripcion: DS.attr('string'),
  prioridad: DS.attr('number'),
  cliente_razon_social: DS.attr('string'),
  cliente_nombre: DS.attr('string'),
  contacto_nombre: DS.attr('string'),
  proyecto_cuenta: DS.attr('string'),
  proyecto_nombre: DS.attr('string'),
  muestras_length: DS.attr('string'),
  servicios_length: DS.attr('string'),
  ultima_cotizacion: DS.attr('string'),
  status_text: DS.attr('string'),
  tipo:  DS.attr('number'),
  datos_usuario: DS.attr('string'),
  created_at: DS.attr('date'),
  orden_compra: DS.attr('string'),

  getDescripcion: function() {
    size =  this.get('descripcion.length');
    data =  this.get('descripcion')
    if (size > 110) {
      data =  data.slice(0,107);
      data =  data + '...';
    }
    return data;
  }.property('descripcion'),

  isTipoI: function() {
    return this.get('tipo') == 1;
  }.property('tipo'),

  isTipoII: function() {
    return this.get('tipo') == 2;
  }.property('tipo'),

  isTipoIII: function() {
    return this.get('tipo') == 3;
  }.property('tipo'),

  isTipoProyecto: function() {
    return this.get('tipo') == 4;
  }.property('tipo')



});
