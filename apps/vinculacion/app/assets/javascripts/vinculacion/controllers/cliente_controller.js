/**
 * Created by calderon on 3/12/14.
 */
App.ClienteController = Ember.ObjectController.extend({
    isNotDirty: Ember.computed.not('content.isDirty')
});