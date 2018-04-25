import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return this.get('store').findAll('conversation', {reload: true}).then(function(conversations) {
      return conversations.filterBy('slug', params.conversation_slug);
    }).then(function(conversations) {
      return conversations.get('firstObject');
    });
  },

  afterModel(model) {
    model.get('messages').forEach(function(message) {
      if (!message.get('belongsToCurrentUser')) {
        message.set('unread', false);
        message.save().catch(() => {});
      }
    });
  }
});
