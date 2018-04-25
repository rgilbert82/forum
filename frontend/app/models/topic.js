import DS from 'ember-data';

export default DS.Model.extend({
  title: DS.attr('string'),
  body: DS.attr('string'),
  slug: DS.attr('string'),
  createdAt: DS.attr('string'),

  user: DS.belongsTo('user'),
  forum: DS.belongsTo('forum', {async: true}),
  posts: DS.hasMany('post'),
  votes: DS.hasMany('vote'),
  topicSaves: DS.hasMany('topic-save'),

  datetime: Ember.inject.service('format-datetime'),

  upvoteCount: Ember.computed('votes.@each.vote', function() {
    return this.get('votes').filterBy('vote', true).get('length');
  }),

  downvoteCount: Ember.computed('votes.@each.vote', function() {
    return this.get('votes').filterBy('vote', false).get('length');
  }),

  voteCount: Ember.computed('upvoteCount', 'downvoteCount', function() {
    return this.get('upvoteCount') - this.get('downvoteCount');
  }),

  formattedDateTime: Ember.computed('createdAt', 'datetime.format', function() {
    return this.get('datetime').format(this.get('createdAt'));
  }),

  commentsCount: Ember.computed('posts', 'posts.length', function() {
    let posts = this.get('posts');

    if (posts) {
      return posts.get('length');
    } else {
      return 0;
    }
  }),

  commentsPluralize: Ember.computed('commentsCount', function() {
    if (this.get('commentsCount') === 1) {
      return 'comment';
    } else {
      return 'comments';
    }
  })
});
