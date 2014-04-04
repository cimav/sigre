App.EnumView = Ember.View.extend({
  items: [
    {id: 0, codigo: "Default-0", descripcion: "Descripción default"}
  ],
  index: 0,

  item: function() {
    var idx = this.get("index");
    if (idx < this.get("items").length) {
      return this.get("items")[idx];
    }
    return "Default";
  }.property()

});

