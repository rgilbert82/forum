import Ember from 'ember';

export default Ember.Controller.extend({
  userSession: Ember.inject.service('user-session'),
  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),
  currentUserChanged: Ember.observer('currentUser', function() {
    this.transitionToRoute('topics', this.get('model').get('slug'));
  }),

  title: '',
  body: '',
  responseMessage: '',
  errorMessage: '',

  titleEmpty: Ember.computed.empty('title'),
  bodyEmpty: Ember.computed.empty('body'),
  isDisabled: Ember.computed.or('titleEmpty', 'bodyEmpty'),
  clearMessages: Ember.computed('responseMessage', 'errorMessage', function() {
    this.set('responseMessage', '');
    this.set('errorMessage', '');
  }),

  actions: {
    createTopic() {
      const title = this.get('title');
      const body = this.get('body');
      const forum = this.get('model');
      const newTopic = this.store.createRecord('topic',
        { title: title, body: body, forum: forum });

      this.get('clearMessages');

      newTopic.save().then((response) => {
        this.transitionToRoute('topics', forum.get('slug'));
      }).catch((response) => {
        this.store.unloadRecord(newTopic);
        this.set('errorMessage', 'Oops! Something went wrong!');
      });

      this.set('title', '');
      this.set('body', '');
    }
  }
});
