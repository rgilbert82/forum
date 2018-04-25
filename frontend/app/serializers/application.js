import DS from 'ember-data';

export default DS.JSONAPISerializer.extend({
  userSession: Ember.inject.service('user-session'),

  serialize(snapshot, options) {
    let json = this._super(...arguments);

    json.data.token = this.get('userSession').getSessionToken();

    return json;
  }
});
