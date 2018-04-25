import Ember from 'ember';

export default Ember.Controller.extend({
  userSession: Ember.inject.service('user-session'),
  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),
  currentUserChanged: Ember.observer('currentUser', function() {
    this.transitionToRoute('forums');
  }),

  username: '',
  password: '',
  responseMessage: '',
  errorMessage: '',

  usernameLength: Ember.computed.gte('username.length', 4),
  passwordLength: Ember.computed.gte('password.length', 6),
  validInputs: Ember.computed.and('usernameLength', 'passwordLength'),
  isDisabled: Ember.computed.not('validInputs'),
  clearMessages: Ember.computed('responseMessage', 'errorMessage', function() {
    this.set('responseMessage', '');
    this.set('errorMessage', '');
  }),

  actions: {
    createUser() {
      const username = this.get('username');
      const password = this.get('password');
      const newUser = this.store.createRecord('user',
        { username: username, password: password });

      this.get('clearMessages');

      newUser.save().then((response) => {
        this.set('responseMessage', 'Thanks for signing up!');
      }).catch((response) => {
        this.store.unloadRecord(newUser);
        this.set('errorMessage', 'Sorry, that username is taken!');
      });

      this.set('username', '');
      this.set('password', '');
    }
  }
});
