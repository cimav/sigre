App.CostoVariableController = Ember.ObjectController.extend({

  tipo_class: function() {
    if (this.get('model.tipo') == 1) {
      c = 'glyphicon glyphicon-user';
    } else if (this.get('model.tipo') == 2) {
      c = 'glyphicon glyphicon-cog';
    } else if (this.get('model.tipo') == 3) {
      c = 'glyphicon glyphicon-tint';
    } else {
      c = 'glyphicon glyphicon-list';
    }
    return c;
  }.property('model.tipo')

});