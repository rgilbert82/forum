import Ember from 'ember';

export default Ember.Controller.extend({
  userSession: Ember.inject.service('user-session'),
  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),

  username: '',
  password: '',
  responseMessage: '',
  errorMessage: '',

  usernameEmpty: Ember.computed.empty('username'),
  passwordEmpty: Ember.computed.empty('password'),
  isDisabled: Ember.computed.or('usernameEmpty', 'passwordEmpty'),
  clearMessages: Ember.computed('responseMessage', 'errorMessage', function() {
    this.set('responseMessage', '');
    this.set('errorMessage', '');
  }),

  actions: {
    login() {
      const username = this.get('username');
      const password = this.get('password');
      const newSession = this.store.createRecord('session',
        { username: username, password: password });

      this.get('clearMessages');

      newSession.save().then((response) => {
        this.get('userSession').login(response);
        this.set('responseMessage', 'You are logged in!');
      }).catch((response) => {
        this.get('store').unloadRecord(newSession);
        this.set('errorMessage', 'Invalid username/password');
      });

      this.set('username', '');
      this.set('password', '');
    },

    logout() {
      this.get('store').findRecord('session', this.get('userSession').getSessionToken(), { backgroundReload: false }).then((session) => {
        session.destroyRecord();
        this.get('userSession').logout();
        this.transitionToRoute('forums');
        this.get('clearMessages');
      });
    }
  }
});
