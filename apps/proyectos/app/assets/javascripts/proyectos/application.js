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
//= require handlebars
//= require ember
//= require ember-data
//= require_self
//= require proyectos/proyectos
//= require proyectos/ember-easyForm
//= require proyectos/bootstrap
//= require select2

var inflector = Ember.Inflector.inflector;
inflector.irregular('proyecto', 'proyectos');
inflector.irregular('proyecto_busqueda', 'proyecto_busqueda');

// Create App
App = Ember.Application.create({
  LOG_TRANSITIONS: true,
  Resolver: Ember.DefaultResolver.extend({
    resolveTemplate: function(parsedName) {
      parsedName.fullNameWithoutType = "proyectos/" + parsedName.fullNameWithoutType;
      return this._super(parsedName);
    }
  }),
  ready: function() {
  }
});

App.ApplicationAdapter = DS.ActiveModelAdapter.extend({});
App.ApplicationSerializer = DS.ActiveModelSerializer.extend({});

DS.RESTAdapter.reopen({
  namespace: "proyectos"
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
