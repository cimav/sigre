Ember.Handlebars.helper('formatPercentage', function(value) {
  return parseFloat(value).toFixed(2).toString().replace(/\d(?=(\d{3})+\.)/g, '$&,') + '%';
});
