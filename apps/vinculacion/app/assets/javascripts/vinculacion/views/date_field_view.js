Ember.Handlebars.registerBoundHelper('format-date', function(format, date) {
  return moment(date).format(format);
});

// TODO App.DateField le fata cambiar a español y a dd/mm/yyyy

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