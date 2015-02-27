Ember.Handlebars.registerBoundHelper('format-date', function(format, date) {
  return moment(date).utc().locale('es').format(format);

});

// TODO App.DateField le falta cambiar a español y a dd/mm/yyyy

App.DateField = Ember.TextField.extend({
  // http://discuss.emberjs.com/t/example-building-a-date-input-field/674/3
  type: 'date',
  date: function(key, date) {
    if (date) {
      this.set('value', date.toISOString().substring(0, 10));
    } else {
      value = this.get('value');
      if (value) {
        date = new Date(value);
      } else {
        date = null;
      }
    }
    return date;
  }.property('value'),
  placeholder: "mm/dd/yyyy",
  size: 12,
  maxLength: 8
});

Em.Handlebars.helper('formatPercent', function(value) {
  value = Math.round(value * 100) / 100;
  return value + '%';
});