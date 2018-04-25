import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return this.get('store').findAll('user', {reload: true}).then(function(users) {
      return users.filterBy('slug', params.slug);
    }).then(function(users) {
      return users.get('firstObject');
    });
  },

  actions: {
    willTransition() {
      let user = this.get('controller.model');

      this.set('controller.editViewHidden', true);
      if (user.get('hasDirtyAttributes')) {
        user.rollbackAttributes();
      }
    }
  }
});
