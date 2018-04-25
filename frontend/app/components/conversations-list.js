import Ember from 'ember';

export default Ember.Component.extend({
  userSession: Ember.inject.service('user-session'),
  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),

  filteredConversations: Ember.computed('trash', 'conversations.@each.inCurrentUserTrash', function() {
    if (this.get('trash')) {
      return this.get('conversations').filter(function(conv) {
        return conv.get('inCurrentUserTrash');
      });
    } else {
      return this.get('conversations').filter(function(conv) {
        return !conv.get('inCurrentUserTrash');
      });
    }
  }),

  conversationsSorting: ['latestMessageDateTime:desc'],
  sortedConversations: Ember.computed.sort('filteredConversations', 'conversationsSorting'),

  conversationsLength: Ember.computed('sortedConversations', 'sortedConversations.length', function() {
    let convs = this.get('sortedConversations');

    if (convs) {
      return convs.get('length');
    } else {
      return 0;
    }
  }),
  nothingHere: Ember.computed.empty('sortedConversations')
});
