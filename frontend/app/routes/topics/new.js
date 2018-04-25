import Ember from 'ember';

export default Ember.Route.extend({
  userSession: Ember.inject.service('user-session'),

  afterModel(model) {
    if (!this.get('userSession').get('currentUser')) {
      this.transitionTo('topics', model.get('slug'));
    }
  },

  actions: {
    willTransition() {
      this.set('controller.title', '');
      this.set('controller.body', '');
    }
  }
});
