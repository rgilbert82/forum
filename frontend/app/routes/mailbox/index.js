import Ember from 'ember';

export default Ember.Route.extend({
  userSession: Ember.inject.service('user-session'),
  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),
  sentConversations: Ember.computed('currentUser.sentConversations', function() {
    return this.get('currentUser').get('sentConversations');
  }),
  receivedConversations: Ember.computed('currentUser.receivedConversations', function() {
    return this.get('currentUser').get('receivedConversations');
  }),
  allConversations: Ember.computed.union('sentConversations', 'receivedConversations'),

  model() {
    return this.get('allConversations');
  }
});
