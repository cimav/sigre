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
//= require select2

inflector = Ember.Inflector.inflector;
inflector.irregular('solicitud', 'solicitudes');

// for more details see: http://emberjs.com/guides/application/
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

DS.RESTAdapter.reopen({
  namespace: "vinculacion"
});

(function() {
   Ember.TextSupport.reopen({
    classNames: ["form-control"]
  });
})();

 
//= require_tree .
