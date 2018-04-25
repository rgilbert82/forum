import Ember from 'ember';

export default Ember.Route.extend({
  userSession: Ember.inject.service('user-session'),

  model() {
    return this.get('userSession').get('currentUser');
  },

  afterModel(model) {
    if (!model) {
      this.transitionTo('forums');
    }
  }
});
