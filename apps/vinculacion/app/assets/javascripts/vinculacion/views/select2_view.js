App.Select2View = Ember.Select.extend({
  classNames: ['form-control'],

  didInsertElement: function() {
    Ember.run.scheduleOnce('afterRender', this, 'processChildElements');
  },

  processChildElements: function() {
    this.$().select2({
      // Config select2
    });
  },

  itemsLoaded : function() {
    Ember.run.sync();
    Ember.run.next(this, function() {
      if (this.$()) {
        this.$().change();
      }
    });
  }.observes('controller.content.isLoaded'),


  willDestroyElement: function () {
    this.$().select2("destroy");
  }
})