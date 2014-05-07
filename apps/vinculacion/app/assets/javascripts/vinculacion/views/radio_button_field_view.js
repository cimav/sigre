//https://gist.github.com/lifeinafolder/6687264

App.RadioButtonGroup = Ember.View.extend({
  classNames: ['ember-radio-button-group'],

  group: 'radio-button-group',

  value: null
});

App.RadioButtonField = Ember.View.extend({
  title: null,

  checked: function () {
    return this.get('parentView.value') === this.get('value');
  }.property('parentView.value').volatile(),

  groupBinding: 'parentView.group',

  disabled: false,

  value: null,

  classNames: ['vwo-radio-button'],

  template: Ember.Handlebars.compile('<label><input type="radio" {{bind-attr disabled="view.disabled" name="view.group" value="view.value" checked="view.checked"}} />{{view.title}}</label>'),

  click: function () {
    this.set('parentView.value', this.get('value'));
  }
});