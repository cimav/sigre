App.ClientesController = Ember.ArrayController.extend({
  needs: ['cliente'],
  searchText: null,
  firstRecord: null,

  arrangedContent: function () {
    search = this.searchText;
    firstRecord = null;
    if (!search) {
      f = this.get('content').get('firstObject');
      if (f) {
        firstRecord = f.id;
        //this.transitionToRoute('muestra', firstRecord);
      }
      return this.get('content');
    }
    return this.get('content').filter(function (item) {
      data_string = item.get('rfc') + item.get('razon_social');
      data_string = data_string.toLowerCase();
      search = search.toLowerCase();
      found = data_string.indexOf(search) != -1;
      if (found && !firstRecord) firstRecord = item.id;
      return found;
    })
  }.property('content', 'searchText'),
  searchChange: function () {
    if (firstRecord) {
      this.transitionToRoute('cliente', firstRecord);
    }
  }.observes('searchText'),

  // TODO arreglar el Prev y Next
  nextCliente: function () {
    this.advanceCliente(1);
  },
  previousCliente: function () {
    this.advanceCliente(-1);
  },
  firstCliente: function () {
    if (this.get('length') > 0) {
      this.transitionToRoute('cliente', this.objectAt(0));
    } else {
      this.transitionToRoute('clientes');
    }
  },
  advanceCliente: function (delta) {
    var clientes = this
    if (clientes.get('length') == 0) {
      this.transitionToRoute('cliente', clientes.objectAt(0));
    } else {
      idx = clientes.indexOf(this.get('content')) + delta;
      if (idx >= 0 && idx <= clientes.get('length') - 1) {
        this.transitionToRoute('clientes.cliente', clientes.objectAt(idx));
      }
    }
  }

});