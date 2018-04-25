import Ember from 'ember';

export default Ember.Controller.extend({
  userSession: Ember.inject.service('user-session'),
  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),

  parentPosts: Ember.computed('model.posts.@each.parent', function() {
    return this.get('model').get('posts').filter(function(post) {
      return !post.get('parent').get('id');
    });
  }),

  isDisabled: Ember.computed.empty('body'),
  clearMessages: Ember.computed('responseMessage', 'errorMessage', function() {
    this.set('responseMessage', '');
    this.set('errorMessage', '');
  }),

  body: '',
  responseMessage: '',
  errorMessage: '',

  actions: {
    createComment() {
      const body = this.get('body');
      const topic = this.get('model');
      const newComment = this.get('store').createRecord('post',
        { body: body, topic: topic });

      this.get('clearMessages');

      newComment.save().then((response) => {
        this.set('responseMessage', 'Thanks for commenting!');
      }).catch((response) => {
        this.get('store').unloadRecord(newComment);
        this.set('errorMessage', 'Oops! Something went wrong!');
      });

      this.set('body', '');
    }
  }
});
