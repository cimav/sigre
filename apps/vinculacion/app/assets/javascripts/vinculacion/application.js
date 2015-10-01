// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// require jquery.ui.all
//= require jquery
//= require handlebars
//= require ember
//= require ember-data
//= require_self
//= require vinculacion/vinculacion
//= require vinculacion/ember-easyForm
//= require vinculacion/bootstrap
//= require vinculacion/moment.min
//= require vinculacion/moment-with-locales.min
//= require select2

var inflector = Ember.Inflector.inflector;
inflector.irregular('solicitud', 'solicitudes');
inflector.irregular('prioridad', 'prioridades');
inflector.irregular('cotizacion', 'cotizaciones');
inflector.irregular('cotizacion_detalle', 'cotizacion_detalle');
inflector.irregular('condicion', 'condiciones');
inflector.irregular('costeo_detalle', 'costeo_detalle');
inflector.irregular('solicitud_busqueda', 'solicitud_busqueda');
inflector.irregular('pais', 'paises');
inflector.irregular('estado', 'estados');
inflector.irregular('costo_variable', 'costos_variables');
inflector.irregular('servicio_bitacora', 'servicios_bitacora');
inflector.irregular('servicioBitacora', 'serviciosBitacora'); //requerido para los Promises
inflector.irregular('laboratorio_bitacora', 'laboratorios_bitacora');
inflector.irregular('laboratorioBitacora', 'laboratoriosBitacora'); //requerido para los Promises
inflector.irregular('muestra_detalle', 'muestras_detalle');

// console.log("test");
// console.log(inflector.pluralize('servicio_bitacora'));    //servicios_bitacora
// console.log(inflector.pluralize('servicios_bitacora'));   //servicios_bitacoras
// console.log(inflector.singularize('servicio_bitacora'));  //servicio_bitacora
// console.log(inflector.singularize('servicios_bitacora')); //servicio_bitacora


// Create App
App = Ember.Application.create({
  LOG_TRANSITIONS: true,
  Resolver: Ember.DefaultResolver.extend({
    resolveTemplate: function(parsedName) {
      parsedName.fullNameWithoutType = "vinculacion/" + parsedName.fullNameWithoutType;
      return this._super(parsedName);
    }
  }),
  ready: function() {
    
  }
});

Ember.Application.initializer({
  name: 'currentUser',
  initialize: function(container) {

    // set default local format time
//    moment.locale('es'); // TODO .format('LL');

    var attributes, controller, store, user;
    store = container.lookup('store:main');
    attributes = $('meta[name="current-user"]').attr('content');
    if (attributes) {
      user = store.push('usuario', store.serializerFor(App.Usuario).normalize(App.Usuario, JSON.parse(attributes)));
      controller = container.lookup('controller:currentUser').set('content', user);
      return container.typeInjection('controller', 'currentUser', 'controller:currentUser');
    }
  }
});
App.ApplicationAdapter = DS.ActiveModelAdapter.extend({});
App.ApplicationSerializer = DS.ActiveModelSerializer.extend({});

DS.RESTAdapter.reopen({
  namespace: "vinculacion"
});

// Add default classes to Ember form views:
(function() {
  Ember.TextSupport.reopen({
    classNames: ['form-control']
  });
  Ember.Select.reopen({
    classNames: ['form-control']
  }); 
})();


// Computed properties
// TODO: Mover a algún archivo
App.computed = {}
App.computed.list_item = function(property) {
  return function() {
    p = this.get(property);
    console.log(p);
    console.log('controllers.application.' + inflector.pluralize(property));
    list = this.get('controllers.application.' + inflector.pluralize(property));
    console.log(list);
    return $.grep(list, function (item) {
      return item.id == p;
    })[0];
  }.property(property);
};
