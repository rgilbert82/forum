import Ember from 'ember';

export default Ember.Route.extend({
  userSession: Ember.inject.service('user-session'),
  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),

  model(params) {
    return this.get('store').findAll('topic', {reload: true}).then(function(topics) {
      return topics.filterBy('slug', params.topic_slug);
    }).then(function(topics) {
      return topics.get('firstObject');
    });
  },

  afterModel(model) {
    let isValidUser;
    let isAdmin;

    if (this.get('currentUser')) {
      isValidUser = model.get('user').get('id') === this.get('currentUser').get('id');
      isAdmin = this.get('currentUser').get('admin');
    } else {
      isValidUser = null;
      isAdmin = null;
    }

    if (!isValidUser && !isAdmin) {
      this.transitionTo('topics.show', model.get('forum').get('slug'), model.get('slug'));
    }
  },

  actions: {
    willTransition() {
      let topic = this.get('controller.model');

      if (topic.get('hasDirtyAttributes')) {
        topic.rollbackAttributes();
      }
    }
  }
});
