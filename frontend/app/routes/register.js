import Ember from 'ember';

export default Ember.Route.extend({
  userSession: Ember.inject.service('user-session'),

  afterModel(model) {
    if (this.get('userSession').get('currentUser')) {
      this.transitionTo('forums');
    }
  },

  actions: {
    willTransition() {
      this.set('controller.username', '');
      this.set('controller.password', '');
      this.set('controller.responseMessage', '');
      this.set('controller.errorMessage', '');
    }
  }
});
