import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return this.get('store').findAll('forum', {reload: true}).then(function(forums) {
      return forums.filterBy('slug', params.slug);
    }).then(function(forums) {
      return forums.get('firstObject');
    });
  },

  actions: {
    willTransition() {
      let forum = this.get('controller.model');

      this.set('controller.editViewHidden', true);
      if (forum.get('hasDirtyAttributes')) {
        forum.rollbackAttributes();
      }
    }
  }
});
