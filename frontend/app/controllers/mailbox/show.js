import Ember from 'ember';

export default Ember.Controller.extend({
  body: '',
  responseMessage: '',
  errorMessage: '',

  userSession: Ember.inject.service('user-session'),
  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),

  isDisabled: Ember.computed.empty('body'),
  clearMessages: Ember.computed('responseMessage', 'errorMessage', function() {
    this.set('responseMessage', '');
    this.set('errorMessage', '');
  }),

  messagesLength: Ember.computed('model.messages.length', function() {
    return this.get('model').get('messages').get('length');
  }),

  otherUser: Ember.computed('model.currentUserIsSender', 'model.sender', 'model.recipient', function() {
    if (this.get('model').get('currentUserIsSender')) {
      return this.get('model').get('recipient');
    } else {
      return this.get('model').get('sender');
    }
  }),

  actions: {
    createMessage() {
      const body = this.get('body');
      const conversation = this.get('model');
      const newMessage = this.store.createRecord('message',
        { body: body, conversation: conversation });

      this.get('clearMessages');

      newMessage.save().then(() => {
        conversation.set('senderTrash', false);
        conversation.set('recipientTrash', false);
        conversation.save().catch(() => {});
      }).catch((response) => {
        this.store.unloadRecord(newMessage);
        this.set('errorMessage', 'Oops! Something went wrong!');
      });

      this.set('body', '');
    }
  }
});
