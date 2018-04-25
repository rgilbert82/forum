import Ember from 'ember';

export default Ember.Component.extend({
  topicsSorting: ['createdAt:desc'],
  sortedTopics: Ember.computed.sort('topics', 'topicsSorting'),
  hasTopics: Ember.computed('topicsLength', function() {
    return this.get('topicsLength') !== 0;
  }),
  topicsLength: Ember.computed('topics', 'topics.length', function() {
    let topics = this.get('topics');

    if (topics) {
      return topics.get('length');
    } else {
      return 0;
    }
  })
});
