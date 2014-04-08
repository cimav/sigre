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
//= require jquery
//= require jquery.ui.all
//= require handlebars
//= require ember
//= require ember-data
//= require_self
//= require vinculacion/vinculacion
//= require vinculacion/ember-easyForm
//= require vinculacion/bootstrap
//= require select2

var inflector = Ember.Inflector.inflector;
inflector.irregular('solicitud', 'solicitudes');
inflector.irregular('prioridad', 'prioridades');
inflector.irregular('cotizacion', 'cotizaciones');
inflector.irregular('cotizacion_detalle', 'cotizaciones_detalle');
inflector.irregular('costeo_detalle', 'costeo_detalle');

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

App.ApplicationAdapter = DS.RESTAdapter();
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
    list = this.get('controllers.application.' + inflector.pluralize(property));
    return $.grep(list, function (item) {
      return item.id == p;
    })[0];
  }.property(property);
};
