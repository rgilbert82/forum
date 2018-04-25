import Ember from 'ember';

export default Ember.Route.extend({
  userSession: Ember.inject.service('user-session'),

  afterModel(model) {
    if (!this.get('userSession').get('currentUser')) {
      this.transitionTo('user', model.get('slug'));
    }
  },

  actions: {
    willTransition() {
      this.set('controller.responseMessage', '');
      this.set('controller.errorMessage', '');
    }
  }
});
