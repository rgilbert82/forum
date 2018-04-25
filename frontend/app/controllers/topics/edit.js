import Ember from 'ember';

export default Ember.Controller.extend({
  userSession: Ember.inject.service('user-session'),
  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),
  currentUserChanged: Ember.observer('currentUser', function() {
    this.transitionToRoute('topics', this.get('model').get('slug'));
  }),

  title: Ember.computed('model.title', function() {
    return this.get('model').get('title');
  }),
  body: Ember.computed('model.body', function() {
    return this.get('model').get('body');
  }),
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
    editTopic() {
      this.get('clearMessages');

      if (this.get('model').get('hasDirtyAttributes')) {
        this.get('model').save().then((response) => {
          this.transitionToRoute('topics.show', this.get('model').get('slug'));
        }).catch((response) => {
          this.get('model').rollbackAttributes();
          this.set('errorMessage', 'Oops! Something went wrong!');
        });
      } else {
        this.transitionToRoute('topics.show', this.get('model').get('slug'));
      }
    },

    deleteTopic() {
      let topic = this.get('model');
      let forum = topic.get('forum').get('slug');

      if (confirm("Are you sure?")) {
        this.get('model').destroyRecord().then((response) => {
          this.transitionToRoute('user', this.get('currentUser').get('slug'));
        }).catch((response) => {
          console.log(response);
        });
      }
    }
  }
});
