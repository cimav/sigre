App.EnumView = Ember.View.extend({
  items: [],
  index: 1,

  item: function() {
    return this.get("items")[this.index-1];
  }.observes('index').property('index')

});

