import Ember from 'ember';

export default Ember.Route.extend({
  userSession: Ember.inject.service('user-session'),

  model() {
    const token = this.get('userSession').getSessionToken();

    if (token) {
      return this.get('store').findRecord('session', token).catch((error) => {
        this.get('userSession').destroySessionToken();
      });
    }
  },

  afterModel(model, transition) {
    this.get('userSession').setCurrentUser(model);
  }
});
