import DS from 'ember-data';

export default DS.Model.extend({
  username: DS.attr('string'),
  password: DS.attr('string'),
  admin: DS.attr('boolean'),
  slug: DS.attr('string'),
  createdAt: DS.attr('string'),

  forums: DS.hasMany('forum'),
  topics: DS.hasMany('topic'),
  posts: DS.hasMany('post'),
  votes: DS.hasMany('vote'),
  topicSaves: DS.hasMany('topic-save'),
  sentConversations: DS.hasMany('conversation', {inverse: 'sender'}),
  receivedConversations: DS.hasMany('conversation', {inverse: 'recipient'}),
  messages: DS.hasMany('message'),

  upvotes: Ember.computed('votes.@each.vote', function() {
    return this.get('votes').filterBy('vote', true);
  }),

  downvotes: Ember.computed('votes.@each.vote', function() {
    return this.get('votes').filterBy('vote', false);
  }),

  upvotedTopics: Ember.computed('upvotes.@each.topic', function() {
    return this.get('upvotes').map(function(vote) {
      return vote.get('topic');
    });
  }),

  downvotedTopics: Ember.computed('downvotes.@each.topic', function() {
    return this.get('downvotes').map(function(vote) {
      return vote.get('topic');
    });
  }),

  savedTopics: Ember.computed('topicSaves.@each.topic', function() {
    return this.get('topicSaves').map(function(saved) {
      return saved.get('topic');
    });
  })
});
