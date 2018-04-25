import DS from 'ember-data';

export default DS.Model.extend({
  title: DS.attr('string'),
  slug: DS.attr('string'),
  senderTrash: DS.attr('boolean'),
  recipientTrash: DS.attr('boolean'),
  createdAt: DS.attr('string'),

  messages: DS.hasMany('message'),
  sender: DS.belongsTo('user', {inverse: 'sentConversations'}),
  recipient: DS.belongsTo('user', {inverse: 'receivedConversations'}),

  userSession: Ember.inject.service('user-session'),
  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),

  datetime: Ember.inject.service('format-datetime'),

  formattedDateTime: Ember.computed('createdAt', 'datetime.format', function() {
    return this.get('datetime').format(this.get('createdAt'));
  }),

  messagesSorting: ['createdAt'],
  sortedMessages: Ember.computed.sort('messages', 'messagesSorting'),

  getLatestMessage: Ember.computed('sortedMessages', 'sortedMessages.@each', function() {
    let sorted = this.get('sortedMessages');

    if (sorted) {
      return sorted.get('lastObject');
    } else {
      return null;
    }
  }),

  latestMessageDateTime: Ember.computed('getLatestMessage', 'formattedDateTime', function() {
    let lastMessage = this.get('getLatestMessage');

    if (lastMessage) {
      return lastMessage.get('formattedDateTime');
    } else {
      return this.get('formattedDateTime');
    }
  }),

  currentUserIsSender: Ember.computed('currentUser', 'currentUser.id', 'sender.id', 'recipient.id', function() {
    let currentUserID;
    let senderID;
    let recipientID;

    if (this.get('currentUser')) {
      currentUserID = this.get('currentUser').get('id');
      senderID = this.get('sender').get('id');
      recipientID = this.get('recipient').get('id');

      if (currentUserID === senderID) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }),

  hasUnreadMessages: Ember.computed('currentUser', 'messages', 'messages.@each.unread', 'messages.@each.user', function() {
    let currentUser = this.get('currentUser');

    if (currentUser) {
      return this.get('messages').filter(function(message) {
        return message.get('unread') && (message.get('user').get('id') !== currentUser.get('id'));
      });
    } else {
      return null;
    }
  }),

  inCurrentUserTrash: Ember.computed('currentUserIsSender', 'senderTrash', 'recipientTrash', function() {
    if (this.get('currentUserIsSender')) {
      return this.get('senderTrash');
    } else {
      return this.get('recipientTrash');
    }
  })
});
