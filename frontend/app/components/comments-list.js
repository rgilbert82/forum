import Ember from 'ember';

export default Ember.Component.extend({
  repliesSortingAsc: ['createdAt'],
  repliesSortingDesc: ['createdAt:desc'],
  sortedRepliesAsc: Ember.computed.sort('replies', 'repliesSortingAsc'),
  sortedRepliesDesc: Ember.computed.sort('replies', 'repliesSortingDesc'),
  hasContent: Ember.computed.or('hasReplies', 'hasComments'),
  hasComments: Ember.computed('commentsLength', function() {
    return this.get('commentsLength') !== 0;
  }),
  commentsLength: Ember.computed('replies', 'replies.@each.editable', 'replies.length', function() {
    let replies = this.get('replies');
    let filtered = 0;

    if (replies) {
      filtered = replies.filter(function(reply) {
        return reply.get('editable');
      }).get('length');
    }

    return filtered;
  })
});
