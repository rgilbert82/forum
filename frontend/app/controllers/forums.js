import Ember from 'ember';

export default Ember.Controller.extend({
  userSession: Ember.inject.service('user-session'),

  name: '',
  responseMessage: '',
  errorMessage: '',
  formHidden: true,

  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),
  isAdmin: Ember.computed('currentUser', function() {
    let user = this.get('currentUser');

    if (user) {
      return user.get('admin');
    } else {
      return null
    }
  }),

  isDisabled: Ember.computed.empty('name'),
  clearMessages: Ember.computed('responseMessage', 'errorMessage', function() {
    this.set('responseMessage', '');
    this.set('errorMessage', '');
  }),

  forumsSorting: ['name'],
  sortedForums: Ember.computed.sort('forums', 'forumsSorting'),

  actions: {
    createForum() {
      const name = this.get('name');
      const newForum = this.get('store').createRecord('forum',
        { name: name });

      this.get('clearMessages');

      newForum.save().then((response) => {
        this.set('responseMessage', 'Thanks for creating a forum!');
      }).catch((response) => {
        this.store.unloadRecord(newForum);
        this.set('errorMessage', 'Oops! Something went wrong!');
      });

      this.set('name', '');
      this.set('formHidden', true);
    },

    toggleFormView() {
      this.set('formHidden', !this.get('formHidden'));
      this.set('name', '');
    }
  }
});
