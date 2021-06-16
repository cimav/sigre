App.Cedula = DS.Model.extend({

  solicitud: DS.belongsTo('solicitud'),
  servicio: DS.belongsTo('servicio'),

  codigo: DS.attr('string'),
  status: DS.attr('number'),

  costos_variables: DS.hasMany('costo_variable'),
  remanentes: DS.hasMany('remanente'),

  total_costo_variable: DS.attr('number'),
  costo_indirecto: DS.attr('number'),
  costo_interno: DS.attr('number'),
  porcentaje_participacion: DS.attr('number'),
  precio_venta: DS.attr('number'),
  utilidad_neta: DS.attr('number'),
  utilidad_topada: DS.attr('number'),
  remanente_distribuible: DS.attr('number'),

  cedula_netmultix: DS.attr('string'),
  cliente_netmultix: DS.belongsTo('cliente_netmultix'),
  concepto_en_extenso: DS.attr('string'),
  observaciones: DS.attr('string'),
  proyecto_id: DS.attr('number'),
  sub_proyecto: DS.attr('string'),

  /*
  relation_string: DS.attr('string'),
  contacto_netmultix: DS.belongsTo('contacto_netmultix'),


  selectsChanges: function() {
    console.log('here > ')
    if (this.get('isDirty')) {
      s = [this.get('cliente_netmultix.id'), this.get('contacto_netmultix.id')].join(',');
      this.set('relation_string', s);
    }
  }.observes('cliente_netmultix'),
*/
  /*
  contactoNetMultixChanges: function() {
    s = [this.get('cliente_netmultix.id'), this.get('contacto_netmultix.id')].join(',');
    // this.set('relation_string', s);

    // this.set('observaciones', this.get('contacto_netmultix.cl06_email'));

  }.observes('contacto_netmultix'),
   */

  /*
                <div class="row">
                    <div class="col-sm-5">
                        {{view App.Select2View contentBinding="cliente_netmultix.contactos_netmultix"
                            optionLabelPath="content.cl06_email"
                            optionValuePath="content.id"
                            selectionBinding="contacto_netmultix"
                            prompt="seleccione contacto netmultix..."
                        }}
                    </div>
                </div>
   */

});