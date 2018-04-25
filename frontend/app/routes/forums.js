import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return Ember.RSVP.hash({
      forums: this.get('store').findAll('forum', {reload: true})
    })
  },

  setupController(controller, model) {
    controller.set('forums', model.forums);
  },

  actions: {
    willTransition() {
      this.set('controller.name', '');
      this.set('controller.formHidden', true);
    }
  }
});
