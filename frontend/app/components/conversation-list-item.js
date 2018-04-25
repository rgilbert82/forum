import Ember from 'ember';

export default Ember.Component.extend({
  userSession: Ember.inject.service('user-session'),
  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),

  userIsSender: Ember.computed('currentUser.currentUserIsSender', function() {
    return this.get('conversation').get('currentUserIsSender');
  }),

  otherUser: Ember.computed('userIsSender', 'conversation.sender', 'conversation.recipient', function() {
    if (this.get('userIsSender')) {
      return this.get('conversation').get('recipient');
    } else {
      return this.get('conversation').get('sender');
    }
  }),

  inTrash: Ember.computed('trash',  function() {
    return this.get('trash');
  }),

  actions: {
    toggleTrashStatus() {
      let conversation = this.get('conversation');

      if (this.get('userIsSender')) {
        conversation.set('senderTrash', !this.get('conversation').get('senderTrash'));
      } else {
        conversation.set('recipientTrash', !this.get('conversation').get('recipientTrash'));
      }

      conversation.save().catch(() => {
        console.log('ERROR!');
      });
    }
  }
});
