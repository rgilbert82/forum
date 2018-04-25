import Ember from 'ember';

export default Ember.Controller.extend({
  userSession: Ember.inject.service('user-session'),
  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),

  title: '',
  body: '',

  titleLength: Ember.computed.gte('title.length', 1),
  bodyLength: Ember.computed.gte('body.length', 1),
  validInputs: Ember.computed.and('titleLength', 'bodyLength'),
  isDisabled: Ember.computed.not('validInputs'),
  clearMessages: Ember.computed('responseMessage', 'errorMessage', function() {
    this.set('responseMessage', '');
    this.set('errorMessage', '');
  }),

  actions: {
    createConversation() {
      let conversation = this.get('store').createRecord('conversation', {
        title: this.get('title'),
        recipient: this.get('model')
      });
      let message = this.get('store').createRecord('message', {
        body: this.get('body')
      });

      this.get('clearMessages');

      conversation.get('messages').pushObject(message);
      conversation.save().then(() => {
        message.save().then(() => {
          this.set('responseMessage', 'Your message has been sent');
          this.set('title', '');
          this.set('body', '');
        }).catch(() => {});
      }).catch(() => {
        this.set('errorMessage', 'Oops! Something went wrong!');
      });
    }
  }
});
