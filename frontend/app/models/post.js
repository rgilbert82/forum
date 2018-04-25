import DS from 'ember-data';

export default DS.Model.extend({
  body: DS.attr('string'),
  editable: DS.attr('boolean'),
  createdAt: DS.attr('string'),

  user: DS.belongsTo('user'),
  topic: DS.belongsTo('topic'),
  parent: DS.belongsTo('post', { inverse: null }),
  replies: DS.hasMany('post', { inverse: null }),

  datetime: Ember.inject.service('format-datetime'),

  formattedDateTime: Ember.computed('createdAt', 'datetime.format', function() {
    return this.get('datetime').format(this.get('createdAt'));
  }),

  childCount: Ember.computed('replies', 'replies.@each.childCount', 'replies.length', function() {
    let posts = this.get('replies');

    if (posts) {
      let count = posts.get('length');
      let childCounts = posts.map(function(post) {
        return post.get('childCount');
      }).reduce(function(sum, value) {
        return sum + value;
      }, 0);

      return count + childCounts;
    } else {
      return 0;
    }
  }),

  childrenPluralize: Ember.computed('childCount', function() {
    if (this.get('childCount') === 1) {
      return 'child';
    } else {
      return 'children';
    }
  })
});
