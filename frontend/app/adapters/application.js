import DS from 'ember-data';

export default DS.JSONAPIAdapter.extend({
  userSession: Ember.inject.service('user-session'),

  namespace: 'api',

  pathForType: function(type) {
    var underscored = Ember.String.underscore(type);
    return Ember.String.pluralize(underscored);
  },

  deleteRecord(store, type, snapshot) {
    var id = snapshot.id;
    var data = { data: { token: this.get('userSession').getSessionToken() } };

    return this.ajax(this.buildURL(type.modelName, id, snapshot, 'deleteRecord'), "DELETE", {
      data
    });
  }
});
