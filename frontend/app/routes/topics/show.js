import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return this.get('store').findAll('topic', {reload: true}).then(function(topics) {
      return topics.filterBy('slug', params.topic_slug);
    }).then(function(topics) {
      return topics.get('firstObject');
    });
  },

  actions: {
    willTransition() {
      this.set('controller.responseMessage', '');
      this.set('controller.errorMessage', '');
    }
  }
});
