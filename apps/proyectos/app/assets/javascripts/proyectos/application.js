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
//= require proyectos/moment.min
//= require proyectos/mixins/ember-shortcuts
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

Ember.Application.initializer({
  name: 'currentUser',
  initialize: function(container) {
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


function humaniseDays (diff) {
  var str = '';
  var values = {
    ' anio': 365,
    ' mes': 30,
    ' día': 1
  };

  for (var x in values) {
    var amount = Math.floor(diff / values[x]);

    if (amount >= 1) {
      str += amount + x + (amount > 1 ? 's' : '') + ' ';
      str = str.replace('mess', 'meses');
      diff -= amount * values[x];
    }
  }

  return str;
}