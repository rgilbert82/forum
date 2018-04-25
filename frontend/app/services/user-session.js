import Ember from 'ember';

export default Ember.Service.extend({
  store: Ember.inject.service('store'),
  login(userSession) {
    this.setSessionToken(userSession.get('id'));
    this.setCurrentUser(userSession);
  },
  logout() {
    this.destroySessionToken();
    this.removeCurrentUser();
  },
  getSessionToken() {
    return localStorage.rgforum196487237
  },
  setSessionToken(token) {
    localStorage.rgforum196487237 = token;
  },
  destroySessionToken() {
    delete localStorage.rgforum196487237;
  },
  setCurrentUser(userSession) {
    if (userSession) {
      this.get('store').findRecord('user', userSession.get('user')).then((record) => {
        this.set('currentUser', record);
        this.get('store').unloadRecord(userSession);
      });
    } else {
      this.removeCurrentUser();
    }
  },
  removeCurrentUser() {
    this.set('currentUser', null);
  },
  currentUser: null
});
